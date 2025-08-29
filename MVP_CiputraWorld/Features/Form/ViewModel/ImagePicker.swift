//
//  ImagePicker.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import SwiftUI
import UIKit

// UIViewController ini buat jembatan antara UIKit (UIImagePickerController) dan SwiftUI, supaya fitur kameranya bisa nyambung
struct ImagePicker: UIViewControllerRepresentable {
    
    // Digunakan untuk menutup/dismiss tampilan kamera/galeri setelah user selesai memilih foto atau cancel.
    @Environment(\.presentationMode) var presentationMode
    
    //sourceType: menentukan apakah mau buka kamera (.camera) atau gallery (.photoLibrary). Default: kamera.
    //onImagePicked: callback yang dipanggil ketika user berhasil memilih/ambil foto (mengembalikan UIImage).
    //onCancel: callback opsional, dipanggil kalau user menekan cancel.
    var sourceType: UIImagePickerController.SourceType = .camera
    var onImagePicked: (UIImage) -> Void
    var onCancel: (() -> Void)? = nil   // ⬅️ Tambahkan callback untuk cancel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Membuat Coordinator sebagai penghubung delegate UIKit ke SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        //Dipanggil saat user berhasil mengambil/memilih gambar
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // Dipanggil kalau user menekan tombol Cancel
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel?() // ⬅️ Panggil callback cancel
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
