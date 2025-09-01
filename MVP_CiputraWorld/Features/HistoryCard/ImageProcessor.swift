//
//  ImageProcessor.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 28/08/25.
//

import Foundation
import UIKit

struct ImageProcessor {
    static func mergeImageWithTimestamp(image: UIImage, timestamp: Date) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let finalImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: image.size.width * 0.045),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            let dateString = timestamp.formatted(date: .abbreviated, time: .standard)
            
            let margin: CGFloat = 50
            let textSize = dateString.size(withAttributes: attrs)
            let textRect = CGRect(
                x: margin,
                y: image.size.height - textSize.height - margin,
                width: textSize.width,
                height: textSize.height
            )
            
            dateString.draw(in: textRect, withAttributes: attrs)
        }
        
        return finalImage
    }
    
    static func saveMergedImage(image: UIImage) -> String? {
        let timestamp = Date()
        
        let finalImage = mergeImageWithTimestamp(image: image, timestamp: timestamp)
        
        guard let data = finalImage.jpegData(compressionQuality: 0.9) else { return nil }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestampString = formatter.string(from: timestamp)

        let filename = "merged_\(timestampString).jpg"
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            print("Saved image at \(fileURL)")
            return filename
        } catch {
                print("Failed to save image: \(error)")
                return nil
        }
    }
    
    static func loadImage(filename: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    static func clearSavedImages() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for url in fileURLs {
                try fileManager.removeItem(at: url)
            }
            
            print("Cleared all saved images from Documents folder")
        } catch {
            print("Failed to clear saved images: \(error)")
        }
    }
}
