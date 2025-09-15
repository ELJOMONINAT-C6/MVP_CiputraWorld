//
//  EquipmentDetailView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct EquipmentDetailView: View {
    @ObservedObject var equipment: Equipment
    @Environment(\.dismiss) var dismiss
    @GestureState private var dragOffset: CGFloat = 0
    @State private var navigateToHistory = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Equipment Image
                if let imagePath = equipment.imagePath, !imagePath.isEmpty {
                    Image(uiImage: UIImage(named: imagePath) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                } else {
                    Image("ac")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8) { // lebih rapat ke lokasi
                    // Title
                    Text(equipment.assetName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // Location as subtitle
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(equipment.assetLocation)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -6)
                    .padding(.bottom, 6)
                    
                    // Top info grid with border lines
                    VStack(spacing: 0) {
                        Divider() // Garis atas
                        
                        HStack(spacing: 0) {
                            InfoColumn(label: "ID", value: equipment.assetID)
                            
                            Divider().frame(height: 40)
                            InfoColumn(
                                label: "INSTALANSI",
                                value: formatDate(equipment.assetSpecification["tanggalInstalasi"] ?? "")
                            )
                            
                            Divider().frame(height: 40)
                            InfoColumn(
                                label: "GARANSI",
                                value: formatDate(equipment.assetSpecification["masaGaransi"] ?? "")
                            )
                        }
                        .padding(.vertical, 6) // jarak teks dengan garis
                        
                        Divider() // Garis bawah
                    }
                    
                    // Specifications
                    Text("Spesifikasi")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(equipment.assetSpecification.keys.sorted().filter { $0 != "xPosition" && $0 != "yPosition" }), id: \.self) { key in
                            if let value = equipment.assetSpecification[key], !value.isEmpty {
                                SpecRow(label: key, value: value)
                            }
                        }
                    }
                    
                    // Button
                    Button(action: {
                        navigateToHistory = true
                    }) {
                        Text("Cek History Card")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundClr)
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationTitle("Informasi Item")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Kembali")
                }
                .foregroundColor(.accentColor)
                .onTapGesture { dismiss() }
            }
        }
        .navigationDestination(isPresented: $navigateToHistory) {
            HistoryListView(
                equipmentID: equipment.id,
                equipmentName: equipment.assetName
            )
        }
        // Swipe gesture
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 50 {
                        dismiss()
                    }
                }
        )
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Components
struct InfoColumn: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SpecRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        Divider()
    }
}
