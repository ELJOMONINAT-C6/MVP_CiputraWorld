//
//  ConfirmationView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
//import SwiftData
import UIKit

//Confirmation View before Submitting to Database
struct ConfirmationView: View {
    
    let historyItem: HistoryItem
    let image: UIImage
    let onSave: () -> Void
    
    // Stating Variables
//    let machine: String
//    let date: Date
//    let details: String
//    let notes: String?
//    let status: String
//    let technician: String

//    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var isSaving: Bool = false
    @State private var saveError: String? = nil
    @State private var showSuccessView: Bool = false   // 👈 NEW

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding()

                VStack(spacing: 4) {
                    Text(historyItem.maintenanceDate.formatted(date: .abbreviated, time: .standard))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
                
                // Foto Ulang Button
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Foto Ulang")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                }
                
                // Submit Button
                Button(action: submitRecord) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(isSaving ? "Menyimpan..." : "Submit")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 15/255, green: 22/255, blue: 58/255)) // navy color
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                }
                .disabled(isSaving)

                Spacer()
            }
            .navigationTitle("Konfirmasi Foto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
            }
            // ✅ Tampilkan SuccessView setelah submit
            .fullScreenCover(isPresented: $showSuccessView) {
                SuccessView(
                    machine: "Peralatan \(historyItem.equipmentID)",
                     date: historyItem.maintenanceDate,
                     details: historyItem.details,
                     notes: historyItem.notes,
                     status: historyItem.status,
                     technician: historyItem.technician,
                     image: image
                )
            }
            .alert("Error", isPresented: Binding(get: { saveError != nil }, set: { _ in saveError = nil })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveError ?? "Unknown error")
            }
        }
    }
    
    private func submitRecord() {
        isSaving = true
        saveError = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSaving = false
            onSave()
            showSuccessView = true
        }
    }

    // Submit Button Handler
//    private func submitRecord() {
//        isSaving = true
//        saveError = nil
//
//        guard let imageData = image.jpegData(compressionQuality: 0.85) else {
//            saveError = "Gagal memproses foto."
//            isSaving = false
//            return
//        }
//
//        let record = HistoryItem(
//            machine: machine,
//            date: date,
//            details: details,
//            notes: notes,
//            photoData: imageData,
//            status: status,
//            technician: technician,
//            spvStatus: "Pending",
//            hodStatus: "Pending"
//        )
//
//        context.insert(record)
//        do {
//            try context.save()
//            onSave()
//            isSaving = false
//            showSuccessView = true   // 👈 pindah ke SuccessView
//        } catch {
//            isSaving = false
//            saveError = "Gagal menyimpan: \(error.localizedDescription)"
//        }
//    }
}

#Preview {
    ConfirmationView(
        historyItem: HistoryItem(
            equipmentID: UUID(),
            maintenanceDate: Date(),
            details: "Perlu pengecekan filter udara.",
            notes: "Filter agak kotor, perlu dibersihkan.",
            status: "Pending",
            technician: "Nathan Gunawan"
        ),
        image: UIImage(systemName: "wrench.and.screwdriver")!,
        onSave: {}
    )
}
