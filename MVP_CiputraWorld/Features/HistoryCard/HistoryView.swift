//
//  HistoryView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @State private var showCamera = false
    @State private var savedImagePath: String?
    @State private var timestamp: Date?
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if let path = savedImagePath,
                       let uiImage = UIImage(contentsOfFile: path) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .ignoresSafeArea()
                            if let ts = timestamp {
                                Text("\(ts.formatted(date: .abbreviated, time: .standard))")
                                    .padding()
                            }
                        }
                    }
                }
                VStack {
                    Button("Open Camera") {
                        showCamera = true
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                saveImage(image)
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
    HistoryView()
}
