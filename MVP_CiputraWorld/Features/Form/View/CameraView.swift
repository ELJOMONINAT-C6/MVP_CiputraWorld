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
    @State var historyItem: HistoryItem
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingInstructionAlert = false
    @State private var capturedImage: UIImage? = nil
    @State private var isShowingCamera = false
    @State private var showConfirmation = false
    @State private var navigateToConfirmation = false
    @State private var timestamp: Date? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.01).ignoresSafeArea()
        }
        .onAppear {
            isShowingInstructionAlert = true
        }
        .alert("Ambil gambar mesin yang di-maintenance", isPresented: $isShowingInstructionAlert) {
            Button("Oke") {
                isShowingCamera = true
            }
        } message: {
            Text("Pastikan kamera jelas dan memiliki pencahayaan yang cukup.")
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(
                sourceType: .camera,
                onImagePicked: { image in
                    let now = Date()
                    self.timestamp = now
                    self.capturedImage = addTimestamp(to: image, date: now)
                    self.isShowingCamera = false
                    self.showConfirmation = true
                    self.navigateToConfirmation = true
                },
                onCancel: {
                    self.dismiss()
                }
            )
        }
        .navigationDestination(isPresented: $navigateToConfirmation) {
            if let imageForConfirm = capturedImage {
                ConfirmationView(
                    historyItem: historyItem,
                    capturedImage: imageForConfirm
                )
            }
        }
    }
    
    // ... (fungsi addTimestamp dan kode lainnya)
    private func addTimestamp(to image: UIImage, date: Date) -> UIImage {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm"
        let dateText = format.string(from: date)
        let text = "Diambil pada \(dateText)"
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { ctx in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: image.size.width * 0.04),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle,
            ]
            
            let padding: CGFloat = 36
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
}
