//
//  FloorCard.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct FloorCard: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
//            .foregroundColor(Color(.label))
            .foregroundColor(Color(.foregroundClr))
            .frame(height: 120)
            .frame(maxWidth: .infinity)
//            .background(Color(.systemBackground))
            .background(Color(.backgroundClr))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)
    }
}

#Preview {
    FloorCard(title: "Lantai 1")
}
