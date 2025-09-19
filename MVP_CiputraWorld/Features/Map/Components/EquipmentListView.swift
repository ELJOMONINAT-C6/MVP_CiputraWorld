//
//  EquipmentListView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct EquipmentListView: View {
    let equipment: [Equipment]
    let searchText: String
    let onSelect: (Equipment) -> Void
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
            List(equipment) { item in
                NavigationLink(destination: EquipmentDetailView(equipment: item)) {
                    EquipmentCardView(equipment: item)
                        .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(.plain)
        }
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
