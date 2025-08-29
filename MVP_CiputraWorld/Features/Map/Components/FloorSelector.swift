//
//  FloorSelector.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct FloorSelector: View {
    @Binding var selectedFloor: Int
    
    var body: some View {
        HStack {
            Text("Lantai:")
                .font(.headline)
            
            Picker("Floor", selection: $selectedFloor) {
                ForEach(1...3, id: \.self) { floor in
                    Text("Lantai \(floor)").tag(floor)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
