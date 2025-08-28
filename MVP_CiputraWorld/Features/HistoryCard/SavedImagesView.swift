//
//  SavedImagesView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import SwiftUI

struct SavedImagesView: View {
    @State private var savedFilenames: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(savedFilenames, id: \.self) { filename in
                    if let uiImage = loadImageFromDocuments(filename: filename) {
                        VStack(alignment: .leading) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                            
                            Text(filename)
                                .lineLimit(1)
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                            // Parse timestamp from file name
                            if let date = extractDateFromFilename(filename) {
                                Text("Captured at: \(date.formatted(date: .abbreviated, time: .standard))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    } else {
                        Text("⚠️ Failed to load \(filename)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Saved Images")
            .onAppear {
                loadSavedFilenames()
            }
        }
    }
    
    func loadImageFromDocuments(filename: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func loadAllSavedFilenames() {
        savedFilenames.removeAll()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let files = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            savedFilenames = files
                .filter { $0.pathExtension.lowercased() == "jpg" }
                .map { $0.lastPathComponent }
        }
    }
    
    private func loadSavedFilenames() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            savedFilenames = files.filter { $0.hasPrefix("merged_") }
        } catch {
            print("❌ Error loading filenames: \(error)")
        }
    }
    
    // Parse timestamp
    func extractDateFromFilename(_ filename: String) -> Date? {
        return nil
    }
}
