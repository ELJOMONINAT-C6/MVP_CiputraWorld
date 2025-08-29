//
//  EquipmentListView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

struct EquipmentListView: View {
    let equipment: [Equipment]
    let onSelect: (Equipment) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hasil Pencarian (\(equipment.count))")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(equipment) { item in
                        EquipmentCardView(equipment: item) {
                            onSelect(item)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}