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
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isUploading)
                    
                    Button("Ambil ulang") {
                        capturedImage = nil
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
                    self.capturedImage = image
                    self.isShowingCamera = false
                },
                onCancel: {
                    self.capturedImage = nil
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
    }
    
    private func uploadAndSave() async {
        isUploading = true
        
        do {
            guard let image = capturedImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mengonversi gambar."])
            }
            
            let fileName = "\(historyItem.id).jpeg"
            let photoPath = "maintenance_photos/\(fileName)"
            
            // Unggah gambar ke Supabase Storage
            try await SupabaseManager.shared.uploadImage(data: imageData, path: photoPath)
            
            // Perbarui historyItem dengan photoURL
            var updatedItem = historyItem
            updatedItem.photoURL = photoPath
            
            // Simpan data history ke Supabase Database
            try await SupabaseManager.shared.insertHistoryItem(item: updatedItem)
            
            alertTitle = "Berhasil"
            alertMessage = "Data maintenance berhasil disimpan."
            showingAlert = true
            
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
