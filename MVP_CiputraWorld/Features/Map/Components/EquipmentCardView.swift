//
//  EquipmentCardView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct EquipmentCardView: View {
    let equipment: sampleEquipment
    let onTap: () -> Void
    
    private var equipmentImage: String {
        if let imagePath = equipment.imagePath,
           ImageManager.shared.loadImage(from: imagePath) != nil {
            return imagePath
        } else {
            return getDefaultImageName()
        }
    }
    
    private func getDefaultImageName() -> String {
        switch equipment.equipmentType {
        case "AC": return "ac"
        case "HCU": return "hcu"
        case "CCTV": return "cctv"
        default: return "ac"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Equipment Image
            Group {
                if let imagePath = equipment.imagePath,
                   let savedImage = ImageManager.shared.loadImage(from: imagePath) {
                    Image(uiImage: savedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(getDefaultImageName())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .clipped()
            
            // Equipment Info
            VStack(alignment: .leading, spacing: 4) {
                Text(equipment.assetName)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
               
                Text("ID: \(equipment.assetID)")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                
              
                Text("Lokasi: \(equipment.assetLocation)")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

