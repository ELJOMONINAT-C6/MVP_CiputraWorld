//
//  CategoryFilterView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//


import SwiftUI

//View for all category
struct CategoryFilterView: View {
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
        
    var body: some View {
        HStack(spacing: 12) {
            CategoryLabel(
                iconType: "AHU",
                color: Color("blue-cw"),
                text: "AHU",
                isSelected: mapViewModel.selectedCategory == "AHU",
                onTap: {
                    mapViewModel.selectCategory("AHU")
                }
            )
            
            CategoryLabel(
                iconType: "FAN",
                color: Color("red-point"),
                text: "FAN",
                isSelected: mapViewModel.selectedCategory == "FAN",
                onTap: {
                    mapViewModel.selectCategory("FAN")
                }
            )
            
            CategoryLabel(
                iconType: "AC",
                color: Color("green-point"),
                text: "AC",
                isSelected: mapViewModel.selectedCategory == "AC",
                onTap: {
                    mapViewModel.selectCategory("AC")
                }
            )
        }
    }
}

// Single category component
struct CategoryLabel: View {
    var iconType: String
    var color: Color
    var text: String
    var isSelected: Bool = false
    var onTap: () -> Void
    
    @ViewBuilder
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)

            switch iconType {
            case "AHU":
                Image("ahu_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)

            case "AC":
                Image("ac_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)

            case "FAN":
                Image(systemName: "fanblades.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)

            default:
                EmptyView()
            }
        }
    }
    
    var body: some View {
        HStack() {
            iconView
            
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            
            Spacer()
            
            Text(text)
                .font(.caption)
                .foregroundColor(isSelected ? Color.black : .primary)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? color.opacity(0.1) : Color(UIColor.systemBackground))
        .frame(maxWidth: 100)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onTap()
        }
    }
}
