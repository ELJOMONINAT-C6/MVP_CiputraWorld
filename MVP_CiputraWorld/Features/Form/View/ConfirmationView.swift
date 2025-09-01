//
//  ConfirmationView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
import SwiftData
import UIKit

/// ConfirmationView previews the captured image and saves the full record to SwiftData.
/// - `onSave` is invoked **before** the view dismisses to inform CameraView that the save succeeded.
struct ConfirmationView: View {
    let machine: String
    let date: Date
    let details: String
    let notes: String?
    let image: UIImage
    let onSave: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var isSaving: Bool = false
    @State private var saveError: String? = nil
    @State private var showSavedAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Photo preview
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding()

                // timestamp + basic info
                Text(date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                // Submit button
                Button(action: submitRecord) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(isSaving ? "Menyimpan..." : "Submit")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .disabled(isSaving)

                // Foto Ulang (retake)
                Button(action: {
                    // Just dismiss this view — CameraView will reopen camera in onChange
                    dismiss()
                }) {
                    Text("Foto Ulang")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray4))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Konfirmasi Foto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        dismiss()
                    }
                }
            }
            .alert("Berhasil", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) {
                    // After acknowledging, dismiss back to CameraView (CameraView will pop if onSave was called)
                    dismiss()
                }
            } message: {
                Text("Data berhasil disimpan.")
            }
            .alert("Error", isPresented: Binding(get: { saveError != nil }, set: { _ in saveError = nil })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveError ?? "Unknown error")
            }
        } // NavigationView
    }

    private func submitRecord() {
        isSaving = true
        saveError = nil

        // Convert image to Data (jpeg)
        guard let imageData = image.jpegData(compressionQuality: 0.85) else {
            saveError = "Gagal memproses foto."
            isSaving = false
            return
        }

        // Create SwiftData HistoryItem (your model). We store photoData directly.
        let record = HistoryItem(
            machine: machine,
            date: date,
            details: details,
            notes: notes,
            photoData: imageData
        )

        context.insert(record)
        do {
            try context.save()
            // Inform CameraView that save succeeded (so it can pop)
            onSave()
            isSaving = false
            showSavedAlert = true
            // Note: we *don't* call dismiss() here immediately so the user sees the success alert.
            // The alert's OK button will dismiss ConfirmationView; CameraView will then pop because onSave was called.
        } catch {
            isSaving = false
            saveError = "Gagal menyimpan: \(error.localizedDescription)"
        }
    }
}
