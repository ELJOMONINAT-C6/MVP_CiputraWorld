//
//  CameraView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import SwiftUI

struct CameraView2: View {
    @State private var showCamera = false
    @State private var savedImagePath: String?
    @State private var timestamp: Date?
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    VStack {
                        if let path = savedImagePath,
                           let uiImage = UIImage(contentsOfFile: path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .ignoresSafeArea()
                        }
                    }
                    VStack {
                        Button("Open Camera") {
                            showCamera = true
                        }
                        .padding()
                        NavigationLink("View Saved Images") {
                            SavedImagesView()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(sourceType: .camera) { image in
                    saveImage(image)
                }
            }
        }
    }
    
    private func saveImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.9) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).jpg")
            do {
                try data.write(to: filename)
                savedImagePath = filename.path
                timestamp = Date()
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    CameraView2()
}
