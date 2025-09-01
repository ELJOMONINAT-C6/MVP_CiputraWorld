//
//  ImagePicker.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    var onImagePicked: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if let filename = ImageProcessor.saveMergedImage(image: image) {
                    print("Successfully saved merged file: \(filename)")
                    
                    if let mergedImage = ImageProcessor.loadImage(filename: filename) {
                        parent.onImagePicked(mergedImage)
                    }
                } else {
                    print("Failed to save merged image")
                    parent.onImagePicked(image)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
