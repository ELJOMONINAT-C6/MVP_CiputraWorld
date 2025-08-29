//
//  EquipmentHelper.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import UIKit

extension Equipment: Identifiable {
    var id: String { assetID }
    
    // Position (get from specification)
    var xPosition: Double {
        Double(spesifikasi["xPosition"] ?? "0") ?? 0
    }
    
    var yPosition: Double {
        Double(spesifikasi["yPosition"] ?? "0") ?? 0
    }
    
    // For Metadata
    var equipmentType: String {
        let components = assetID.components(separatedBy: "-")
        return components.first ?? "Unknown"
    }
    
    var floor: Int {
        if lokasiPemasangan.lowercased().contains("lantai 1") {
            return 1
        } else if lokasiPemasangan.lowercased().contains("lantai 2") {
            return 2
        } else if lokasiPemasangan.lowercased().contains("lantai 3") {
            return 3
        }
        return 1 // default lantai 1
    }
    
    var isActive: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let warrantyDate = formatter.date(from: masaGaransi) else { return true }
        return warrantyDate > Date()
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
