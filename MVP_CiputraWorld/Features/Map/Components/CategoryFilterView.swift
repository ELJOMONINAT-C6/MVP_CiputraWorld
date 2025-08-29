//
//  CategoryFilterView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//


import SwiftUI

// MARK: - Komponen untuk Filter Kategori
struct CategoryFilterView: View {
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
        
    var body: some View {
        HStack(spacing: 12) {
            CategoryLabel(
                color: Color("blue-cw"),
                text: "AC",
                isSelected: mapViewModel.selectedCategory == "AC",
                onTap: {
                    mapViewModel.selectCategory("AC")
                }
            )
            
            CategoryLabel(
                color: Color("red-point"),
                text: "HCU",
                isSelected: mapViewModel.selectedCategory == "HCU",
                onTap: {
                    mapViewModel.selectCategory("HCU")
                }
            )
            
            CategoryLabel(
                color: Color("green-point"),
                text: "CCTV",
                isSelected: mapViewModel.selectedCategory == "CCTV",
                onTap: {
                    mapViewModel.selectCategory("CCTV")
                }
            )
        }
    }
}

// MARK: - Komponen untuk Label Tunggal
struct CategoryLabel: View {
    var color: Color
    var text: String
    var isSelected: Bool = false // Tambah state selected
    var onTap: () -> Void // Tambah action
    
    var body: some View {
        HStack() {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            
            Spacer()
            
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? color.opacity(0.1) : Color.white)
        .frame(maxWidth: 100)
        .cornerRadius(15)
        .overlay(
            // Border jika dipilih
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
        )
        .onTapGesture { // Tambah tap gesture
            onTap()
        }
    }
}
