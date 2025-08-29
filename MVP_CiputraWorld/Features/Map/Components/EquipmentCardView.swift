//
//  EquipmentCardView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

struct EquipmentCardView: View {
    let equipment: Equipment
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(equipment.isActive ? .green : .red)
                    .frame(width: 8, height: 8)
                
                Text(equipment.assetID)
                    .font(.caption)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(equipment.equipmentType)
                    .font(.caption2)
                    .padding(2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(equipment.namaAlat)
                .font(.caption2)
                .lineLimit(2)
            
            Text("Lantai \(equipment.floor)")
                .font(.caption2)
                .foregroundColor(.gray)
            
            if let merk = equipment.spesifikasi["Merk"] {
                Text("Merk: \(merk)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .frame(width: 140, height: 90)
        .onTapGesture {
            onTap()
        }
    }
}