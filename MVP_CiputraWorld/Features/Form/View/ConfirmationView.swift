//
//  ConfirmationView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
import UIKit

@MainActor
struct ConfirmationView: View {
    let historyItem: HistoryItem
    let capturedImage: UIImage
    
    @Environment(\.dismiss) private var dismiss // Gunakan ini untuk kembali
    
    @State private var isUploading = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var navigateToSuccessView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(uiImage: capturedImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 360)
                .cornerRadius(12)
                .padding()
            
            if isUploading {
                ProgressView("Mengunggah dan menyimpan data...")
                    .padding()
            }
            
//            Button("Simpan Data") {
//                Task {
//                    await uploadAndSave()
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(isUploading)
            
            Button(action: {
                Task { await uploadAndSave() }
            }) {
                Text("Simpan data")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 35)
            }
            .disabled(isUploading)
            .buttonStyle(.borderedProminent)
            .tint(.backgroundClr)
            .foregroundColor(.foregroundClr)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .accessibilityHint("Tekan untuk melihat data yang telah diisi")
            
//            Button("Ambil ulang") {
//                dismiss()
//            }
            Button(action: {
                Task { dismiss() }
            }) {
                Text("Ambil ulang")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 35)
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Konfirmasi Foto")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToSuccessView) {
            SuccessView(
                machine: historyItem.equipmentID.uuidString,
                date: historyItem.maintenanceDate,
                details: historyItem.details,
                notes: historyItem.notes,
                status: historyItem.status,
                technician: historyItem.technician,
                image: capturedImage
            )
        }
    }
    
    private func uploadAndSave() async {
        isUploading = true
        
        do {
            guard let imageData = capturedImage.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mengonversi gambar."])
            }
            
            let insertedItem = try await SupabaseManager.shared.insertHistoryItem(item: historyItem)
            guard let validID = insertedItem.id else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mendapatkan ID item yang disimpan."])
            }
            
            let fileName = "\(validID).jpeg"
            let photoPath = "maintenance-photos/\(fileName)"
            
            try await SupabaseManager.shared.uploadImage(data: imageData, path: photoPath)
            try await SupabaseManager.shared.updateHistoryItemPhoto(id: validID, photoURL: photoPath)
            
            // Setelah berhasil, picu navigasi
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
