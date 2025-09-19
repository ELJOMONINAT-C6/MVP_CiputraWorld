//
//  EquipmentHelper.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import UIKit

extension Equipment {
    
    // Position (get from specification)
    var xPosition: Double {
        Double(assetSpecification["xPosition"] ?? "0") ?? 0
    }
    
    var yPosition: Double {
        Double(assetSpecification["yPosition"] ?? "0") ?? 0
    }
    
    // For Metadata
    var equipmentType: String {
        let components = assetName.split(separator: " ")
        return components.first.map { String($0) } ?? "Unknown"
    }
}

class ImageManager {
    static let shared = ImageManager()
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveImage(_ image: UIImage, with filename: String) -> String? {
        let imageURL = documentsDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        do {
            try data.write(to: imageURL)
            return imageURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    
    func getDefaultImage(for equipmentType: String) -> String {
        switch equipmentType {
        case "AC": return "ac_default"
        case "HCU": return "hcu_default"
        case "CCTV": return "cctv_default"
        default: return "equipment_default"
        }
    }
}

