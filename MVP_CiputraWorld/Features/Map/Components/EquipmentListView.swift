//
//  EquipmentListView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct EquipmentListView: View {
    let equipment: [sampleEquipment]  // Menggunakan sampleEquipment
    let searchText: String
    let onSelect: (sampleEquipment) -> Void  // Menggunakan sampleEquipment
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("\(equipment.count) hasil ditemukan untuk \"\(searchText)\"")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding()
            .background(Color("darkblue"))
            
            // Equipment List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(equipment) { item in
                        EquipmentCardView(equipment: item) {  // Menggunakan sampleEquipment
                            onSelect(item)
                        }
                    }
                }
                .padding()
            }
            .background(Color.white)
        }
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
    }
}

// Extension untuk corner radius spesifik
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
