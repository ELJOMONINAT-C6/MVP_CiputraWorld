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
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
    
    //    private var iconView: some View {
    //        let categoryToUse = mapViewModel.selectedCategory ?? equipment.equipmentType
    //
    //        switch categoryToUse {
    //        case "AHU":
    //            // External asset
    //            return AnyView(
    //                Image("ahu_icon")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .frame(width: pointSize * 0.6, height: pointSize * 0.6)
    //            )
    //        case "AC":
    //            // External asset
    //            return AnyView(
    //                Image("ac_icon")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .frame(width: pointSize * 0.6, height: pointSize * 0.6)
    //            )
    //        case "FAN":
    //            // Built-in SF Symbol
    //            return AnyView(
    //                Image(systemName: "fanblades.fill")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .frame(width: pointSize * 0.6, height: pointSize * 0.6)
    //                    .foregroundColor(.white) // keep it visible
    //            )
    //        default:
    //            // Fallback SF Symbol
    //            return AnyView(
    //                Image(systemName: "questionmark.circle.fill")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .frame(width: pointSize * 0.6, height: pointSize * 0.6)
    //                    .foregroundColor(.white)
    //            )
    //        }
    //    }
    
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
        return isSelected ? 24 : 18
    }
    
    var body: some View {
//        ZStack {
            Circle()
                .fill(pointColor)
                .frame(width: pointSize, height: pointSize)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.red : Color.white, lineWidth: isSelected ? 3 : 2)
                )
        //        iconView
//        }
        .overlay(
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
        //.accessibilityHint("Tap here to see \(equipment.assetName) with ID \(equipment.assetID) details")
    }
}
