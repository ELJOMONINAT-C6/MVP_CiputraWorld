//
//  EquipmentPointView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

struct EquipmentPointView: View {
    let equipment: sampleEquipment  // Menggunakan sampleEquipment
    let geometrySize: CGSize
    let isSelected: Bool
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
    
    private var pointColor: Color {
        let categoryToUse = mapViewModel.selectedCategory ?? equipment.equipmentType
        
        switch categoryToUse {
        case "AHU":
            return Color("blue-cw")
        case "FAN":
            return Color("red-point")
        case "AC":
            return Color("green-point")
        default:
            return .purple
        }
    }
    
    private var pointSize: CGFloat {
        return isSelected ? 16 : 12
    }
    
    var body: some View {
        Circle()
            .fill(pointColor)
            .frame(width: pointSize, height: pointSize)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.red : Color.white, lineWidth: isSelected ? 3 : 2)
            )
            .overlay(
                // Pulse animation for selected equipment
                Group {
                    if isSelected {
                        Circle()
                            .stroke(pointColor.opacity(0.4), lineWidth: 2)
                            .scaleEffect(1.5)
                            .opacity(0.6)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isSelected)
                    }
                }
            )
            .position(
                x: equipment.xPosition,  // Menggunakan xPosition dari sampleEquipment
                y: equipment.yPosition   // Menggunakan yPosition dari sampleEquipment
            )
    }
}
