//
//  EquipmentPointView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

struct EquipmentPointView: View {
    let equipment: Equipment
    let geometrySize: CGSize
    let isSelected: Bool
    let onTap: () -> Void
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
    
    private var pointColor: Color {
        let categoryToUse = mapViewModel.selectedCategory ?? equipment.equipmentType
        
        switch categoryToUse {
        case "AC":
            return Color("blue-cw")
        case "HCU":
            return Color("red-point")
        case "CCTV":
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
                x: equipment.xPosition,
                y: equipment.yPosition
            )
            .onTapGesture {
                onTap()
            }
            .overlay(
                // Equipment ID label
                Text(equipment.assetID)
                    .font(.caption2)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(4)
                    .position(
                        x: equipment.xPosition,
                        y: equipment.yPosition - 25
                    )
            )
    }
}
