//
//  FloorCard.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct FloorCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .overlay(Color("darkblue").opacity(0.7))
                .cornerRadius(12)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FloorCard(title: "Lantai 1", imageName: "map")
}
