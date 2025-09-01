//
//  CameraView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
import UIKit

struct CameraView: View {
    let machine: String
    let date: Date
    let details: String
    let notes: String?

    @Environment(\.dismiss) private var dismiss

    @State private var showCamera: Bool = false
    @State private var capturedImage: UIImage? = nil
    @State private var showConfirmation: Bool = false
    @State private var savedSuccessfully: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.01)
                .ignoresSafeArea()

            VStack {
                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 360)
                        .cornerRadius(12)
                        .padding()
                } else {
                    Color.clear
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                showCamera = true
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(
                sourceType: .camera,
                onImagePicked: { image in
                    capturedImage = image
                    showConfirmation = true
                },
                onCancel: {
                    dismiss() // langsung keluar jika cancel kamera
                }
            )
        }
        .fullScreenCover(isPresented: $showConfirmation) {
            if let imageForConfirm = capturedImage {
                ConfirmationView(
                    machine: machine,
                    date: date,
                    details: details,
                    notes: notes,
                    image: imageForConfirm,
                    onSave: {
                        savedSuccessfully = true
                    }
                )
            }
        }
        .onChange(of: showConfirmation) { newValue in
            if !newValue {
                if savedSuccessfully {
                    // Jika berhasil save → kembali ke InputView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        if !showCamera { // pastikan kamera sudah tertutup
                            dismiss()
                        }
                    }
                } else {
                    // Jika tidak save → buka kamera lagi (foto ulang)
                    capturedImage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        if !savedSuccessfully {
                            showCamera = true
                        }
                    }
                }
            }
        }
    }
}
