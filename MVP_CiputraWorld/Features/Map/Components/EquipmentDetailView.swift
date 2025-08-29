//
//  EquipmentDetailView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

struct EquipmentDetailView: View {
    let equipment: Equipment
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(equipment.assetID)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            StatusBadge(isActive: equipment.isActive)
                        }
                        
                        Text(equipment.namaAlat)
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(equipment.lokasiPemasangan)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Installation Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Informasi Instalasi")
                            .font(.headline)
                        
                        InfoRow(title: "Tanggal Instalasi", value: formatDate(equipment.tanggalInstalasi))
                        InfoRow(title: "Masa Garansi", value: formatDate(equipment.masaGaransi))
                        InfoRow(title: "Lantai", value: "Lantai \(equipment.floor)")
                        InfoRow(title: "Tipe", value: equipment.equipmentType)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Specifications
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spesifikasi")
                            .font(.headline)
                        
                        ForEach(Array(equipment.spesifikasi.keys.sorted()), id: \.self) { key in
                            if let value = equipment.spesifikasi[key] {
                                InfoRow(title: key, value: value)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Detail Equipment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
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