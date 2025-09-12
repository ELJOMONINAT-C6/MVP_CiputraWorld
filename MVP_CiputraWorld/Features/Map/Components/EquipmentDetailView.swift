//
//  EquipmentDetailView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct EquipmentDetailView: View {
    @ObservedObject var equipment: Equipment
    @Environment(\.presentationMode) var presentationMode
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
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.1))
                } else {
                    Image("ac")
                        .resizable()
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.1))
                }
                
                //Mandatory Attributes
                VStack() {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(equipment.assetName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ID: \(equipment.assetID)")
                                .font(.body)
                            
                            Text("Lokasi: \(equipment.assetLocation)")
                                .font(.body)
                            
                            Text("Last Maintenance: \(formatDate(equipment.assetSpecification["tanggalInstalasi"] ?? ""))")
                                .font(.body)
                            
                            Text("Next Maintenance: \(formatDate(equipment.assetSpecification["masaGaransi"] ?? ""))")
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Specifications Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spesifikasi")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(equipment.assetSpecification.keys.sorted().filter { $0 != "xPosition" && $0 != "yPosition" }), id: \.self) { key in
                                if let value = equipment.assetSpecification[key], !value.isEmpty {
                                    SpecificationRow(title: "\(key):", value: value)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    // History Card Button
                    Button(action: {
                        navigateToHistory = true
                    }) {
                        Text("Cek History Card")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.foregroundClr)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundClr)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    Spacer(minLength: 50)
                }
                .padding()
            }
        }
        .navigationTitle("Informasi Item")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Kembali")
                }
            }
        )
        .navigationDestination(isPresented: $navigateToHistory) {
            // Langsung ke HistoryListView tanpa filter tanggal - ambil semua history
            HistoryListView(
                equipmentID: equipment.id,
                equipmentName: equipment.assetName
            )
        }
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
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

// Helper view untuk specification row
struct SpecificationRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

