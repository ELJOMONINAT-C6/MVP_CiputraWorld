//
//  CameraView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 29/08/2025.
//

import SwiftUI
import UIKit

// View for Camera
struct CameraView: View {
    
    //Defining Variables
    let machine: String
    let date: Date
    let details: String
    let notes: String?
    let status: String
    let technician: String

    // handler for if user press cancel, or proceed, so it can dismiss the current appearing page
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
        } // auto open camera when load, set showcamera to true
        .onAppear {
            DispatchQueue.main.async {
                showCamera = true
            }
        } //controls if the user cancel (go back to the previous page) or decide to proceed to ConfirmationView
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
        } // open confirmationview
        .fullScreenCover(isPresented: $showConfirmation) {
            if let imageForConfirm = capturedImage {
                ConfirmationView(
                    machine: machine,
                    date: date,
                    details: details,
                    notes: notes,
                    status: status,
                    technician: technician,
                    image: imageForConfirm,
                    onSave: {
                        savedSuccessfully = true
                    }
                )
            }
        }
        .onChange(of: showConfirmation) { newValue in
            if !newValue {
                // If saved → close CameraView entirely
                if savedSuccessfully {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        if !showCamera {
                            dismiss()
                        }
                    }
                    // If not saved >> reset image & reopen camera (Retake)
                } else {
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
