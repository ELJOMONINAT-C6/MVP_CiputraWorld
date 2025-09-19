//
//  CategoryFilterView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct EquipmentCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconType: String
    let color: Color
}

// Segmented Control View
struct CategoryFilterView: View {
    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
    
    private let categories: [EquipmentCategory] = [
        EquipmentCategory(name: "AHU", iconType: "ahu_icon", color: Color("blue-cw")),
        EquipmentCategory(name: "FAN", iconType: "fanblades.fill", color: Color("red-point")),
        EquipmentCategory(name: "AC", iconType: "ac_icon", color: Color("green-point"))
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(categories.indices, id: \.self) { index in
                let category = categories[index]
                CategorySegmentButton(
                    category: category,
                    isSelected: mapViewModel.selectedCategory == category.name
                ) {
                    mapViewModel.selectCategory(category.name)
                }
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .clipShape(segmentShape(for: index))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 1)
                .fill(Color(UIColor.secondarySystemBackground))
                .opacity(0.3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
    }
    
    private func segmentShape(for index: Int) -> some Shape {
        let first = index == 0
        let last = index == categories.count - 1
        
        if first {
            return AnyShape(RoundedCornerShape(corners: [.topLeft, .bottomLeft], radius: 8))
        } else if last {
            return AnyShape(RoundedCornerShape(corners: [.topRight, .bottomRight], radius: 8))
        } else {
            return AnyShape(Rectangle())
        }
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Segment Button
struct CategorySegmentButton: View {
    let category: EquipmentCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                iconView
                
                Text(category.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .label : .primary)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ?
                          Color(.foregroundClr) :
                          Color(UIColor.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Icon View
    @ViewBuilder
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(category.color)
                .frame(width: 20, height: 20)
            
            switch category.iconType {
            case "ahu_icon":
                Image("ahu_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            case "ac_icon":
                Image("ac_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            case "fanblades.fill":
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
}

// MARK: - Preview
#Preview {
    CategoryFilterView(mapViewModel: EquipmentFilteringViewModel())
}

//import SwiftUI
//
////View for all category
//struct CategoryFilterView: View {
//    @ObservedObject var mapViewModel: EquipmentFilteringViewModel
//        
//    var body: some View {
//        HStack(spacing: 12) {
//            CategoryLabel(
//                iconType: "AHU",
//                color: Color("blue-cw"),
//                text: "AHU",
//                isSelected: mapViewModel.selectedCategory == "AHU",
//                onTap: {
//                    mapViewModel.selectCategory("AHU")
//                }
//            )
//            
//            CategoryLabel(
//                iconType: "FAN",
//                color: Color("red-point"),
//                text: "FAN",
//                isSelected: mapViewModel.selectedCategory == "FAN",
//                onTap: {
//                    mapViewModel.selectCategory("FAN")
//                }
//            )
//            
//            CategoryLabel(
//                iconType: "AC",
//                color: Color("green-point"),
//                text: "AC",
//                isSelected: mapViewModel.selectedCategory == "AC",
//                onTap: {
//                    mapViewModel.selectCategory("AC")
//                }
//            )
//        }
//    }
//}
//
//// Single category component
//struct CategoryLabel: View {
//    var iconType: String
//    var color: Color
//    var text: String
//    var isSelected: Bool = false
//    var onTap: () -> Void
//    
//    @ViewBuilder
//    private var iconView: some View {
//        ZStack {
//            Circle()
//                .fill(color)
//                .frame(width: 24, height: 24)
//
//            switch iconType {
//            case "AHU":
//                Image("ahu_icon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 14, height: 14)
//                    .foregroundColor(.white)
//
//            case "AC":
//                Image("ac_icon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 14, height: 14)
//                    .foregroundColor(.white)
//
//            case "FAN":
//                Image(systemName: "fanblades.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 14, height: 14)
//                    .foregroundColor(.white)
//
//            default:
//                EmptyView()
//            }
//        }
//    }
//    
//    var body: some View {
//        HStack() {
//            ZStack{
//                Circle()
//                    .fill(color)
//                    .frame(width: 20, height: 20)
//                
//                iconView
//            }
//            
//            Spacer()
//            
//            Text(text)
//                .font(.caption)
//                .foregroundColor(isSelected ? Color.black : .primary)
//            
//            Spacer()
//        }
//        .padding(.horizontal, 10)
//        .padding(.vertical, 6)
//        .background(isSelected ? color.opacity(0.1) : Color(UIColor.systemBackground))
//        .frame(maxWidth: 100)
//        .cornerRadius(15)
//        .overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
//        )
//        .onTapGesture {
//            onTap()
//        }
//    }
//}
