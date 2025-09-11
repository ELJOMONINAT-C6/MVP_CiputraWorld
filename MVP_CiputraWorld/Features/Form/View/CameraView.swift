//
//  CameraView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
import UIKit
import Supabase

@MainActor
struct CameraView: View {
    // HistoryItem yang sudah diisi dari InputView
    @State var historyItem: HistoryItem
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var capturedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @State private var isUploading = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var timestamp: Date? = nil
    
    @State private var navigateToSuccessView = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.01).ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 360)
                        .cornerRadius(12)
                        .padding()
                    
                    if isUploading {
                        ProgressView("Mengunggah dan menyimpan data...")
                            .padding()
                    }
                    
                    Button("Simpan Data") {
                        Task {
                            await uploadAndSave()
                            navigateToSuccessView = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isUploading)
                    
                    Button("Ambil ulang") {
                        capturedImage = nil
                        timestamp = nil
                        isShowingCamera = true
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    Text("Ambil gambar mesin yang akan di-maintenance")
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(.headline)
                    
                    Button("Buka Kamera") {
                        isShowingCamera = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Ambil Gambar")
        .onAppear {
            isShowingCamera = true
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(
                sourceType: .camera,
                onImagePicked: { image in
                    let now = Date()
                    self.timestamp = now
                    // 🔹 Tambahkan watermark timestamp ke gambar
                    self.capturedImage = addTimestamp(to: image, date: now)
                    self.isShowingCamera = false
                },
                onCancel: {
                    self.capturedImage = nil
                    self.timestamp = nil
                    self.isShowingCamera = false
                }
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertTitle == "Berhasil" {
                    dismiss()
                }
            })
        }
        
        .navigationDestination(isPresented: $navigateToSuccessView) {
            SuccessView(
                machine: historyItem.equipmentID.uuidString,
                date: historyItem.maintenanceDate,
                details: historyItem.details,
                notes: historyItem.notes,
                status: historyItem.status,
                technician: historyItem.technician,
                image: capturedImage ?? UIImage()
            )
        }
    }
    
    private func addTimestamp(to image: UIImage, date: Date) -> UIImage {
       let format = DateFormatter()
       format.dateFormat = "dd/MM/yyyy HH:mm"
       let dateText = format.string(from: date)
        let text = "Diambil pada \(dateText)"
       
//       let scale = UIScreen.main.scale
       let renderer = UIGraphicsImageRenderer(size: image.size)
       return renderer.image { ctx in
           image.draw(in: CGRect(origin: .zero, size: image.size))
           
           // Style teks
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = .left
           
           let attrs: [NSAttributedString.Key: Any] = [
               .font: UIFont.boldSystemFont(ofSize: image.size.width * 0.04),
               .foregroundColor: UIColor.white,
               .paragraphStyle: paragraphStyle,
           ]
           
           let padding: CGFloat = 16
           let attributedText = NSAttributedString(string: text, attributes: attrs)
           let textSize = attributedText.size()
           let rect = CGRect(
               x: padding,
               y: image.size.height - textSize.height - padding,
               width: textSize.width,
               height: textSize.height
           )
           attributedText.draw(in: rect)
       }
   }
    
    private func uploadAndSave() async {
        isUploading = true
        
        do {
            guard let image = capturedImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mengonversi gambar."])
            }
            
            let insertedItem = try await SupabaseManager.shared.insertHistoryItem(item: historyItem)
               guard let validID = insertedItem.id else {
                   throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mendapatkan ID item yang disimpan."])
               }
            
            let fileName = "\(validID).jpeg"
            let photoPath = "maintenance-photos/\(fileName)"
            
            // Unggah gambar ke Supabase Storage
            try await SupabaseManager.shared.uploadImage(data: imageData, path: photoPath)
            
            // Simpan data history ke Supabase Database
            try await SupabaseManager.shared.updateHistoryItemPhoto(id: validID, photoURL: photoPath)
            
            navigateToSuccessView = true
            
        } catch {
            print("Error: \(error)")
            alertTitle = "Gagal"
            alertMessage = "Terjadi kesalahan: \(error.localizedDescription)"
            showingAlert = true
        }
        
        isUploading = false
    }
}

// View for Camera
//struct CameraView: View {
//    
//    //Defining Variables
//    let machine: String
//    let date: Date
//    let details: String
//    let notes: String?
//    let status: String
//    let technician: String
//
//    // handler for if user press cancel, or proceed, so it can dismiss the current appearing page
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var showCamera: Bool = false
//    @State private var capturedImage: UIImage? = nil
//    @State private var showConfirmation: Bool = false
//    @State private var savedSuccessfully: Bool = false
//    
//    // 👇 Add state for showing the alert
//    @State private var showInstructionAlert: Bool = false
//
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.01)
//                .ignoresSafeArea()
//
//            VStack {
//                if let img = capturedImage {
//                    Image(uiImage: img)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxHeight: 360)
//                        .cornerRadius(12)
//                        .padding()
//                } else {
//                    Color.clear
//                }
//            }
//        }
//        // auto open camera when load, set showcamera to true
//        .onAppear {
//            DispatchQueue.main.async {
//                // First show instruction popup
//                showInstructionAlert = true
//            }
//        }
//        // 👇 The alert you showed in screenshot
//        .alert("Ambil Gambar", isPresented: $showInstructionAlert) {
//            Button("Oke") {
//                // When user taps OK → then open the camera
//                showCamera = true
//            }
//        } message: {
//            Text("Pastikan kamera jelas dan memiliki pencahayaan yang cukup")
//        }
//        // Camera sheet
//        .sheet(isPresented: $showCamera) {
//            ImagePicker(
//                sourceType: .camera,
//                onImagePicked: { image in
//                    capturedImage = image
//                    showConfirmation = true
//                },
//                onCancel: {
//                    dismiss() // langsung keluar jika cancel kamera
//                }
//            )
//        }
//        // Confirmation view
//        .fullScreenCover(isPresented: $showConfirmation) {
//            if let imageForConfirm = capturedImage {
//                let processedImage = ImageProcessor.mergeImageWithTimestamp(image: imageForConfirm, timestamp: date)
//                
//                ConfirmationView(
//                    machine: machine,
//                    date: date,
//                    details: details,
//                    notes: notes,
//                    status: status,
//                    technician: technician,
//                    image: processedImage,
//                    onSave: {
//                        savedSuccessfully = true
//                    }
//                )
//            }
//        }
//        // Handle dismissal after confirmation
//        .onChange(of: showConfirmation) { newValue in
//            if !newValue {
//                if savedSuccessfully {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
//                        if !showCamera {
//                            dismiss()
//                        }
//                    }
//                } else {
//                    capturedImage = nil
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
//                        if !savedSuccessfully {
//                            showCamera = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
