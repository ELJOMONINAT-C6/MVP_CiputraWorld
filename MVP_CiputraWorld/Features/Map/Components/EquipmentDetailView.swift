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
        ScrollView {
            VStack(spacing: 20) {
                // Equipment Image
                Image("ac") // Ganti dengan nama image yang sesuai
                    .resizable()
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                
                // Equipment Image
//                Group {
//                    if let imagePath = equipment.imagePath,
//                       let uiImage = ImageManager.shared.loadImage(from: imagePath) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 200)
//                    } else {
//                        // Fallback ke default image
//                        Image(ImageManager.shared.getDefaultImage(for: equipment.equipmentType))
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 200)
//                    }
//                }
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(12)
                
                VStack() {
                    // Equipment Name and Basic Info
                    VStack(alignment: .leading, spacing: 16) {
                        Text(equipment.namaAlat)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ID: \(equipment.assetID)")
                                .font(.body)
                            
                            Text("Lokasi: \(equipment.lokasiPemasangan)")
                                .font(.body)
                            
                            Text("Last Maintenance: \(formatDate(equipment.tanggalInstalasi))")
                                .font(.body)
                            
                            Text("Next Maintenance: \(formatDate(equipment.masaGaransi))")
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Specifications Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spesifikasi")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            // Hardcoded specifications based on image
//                            SpecificationRow(title: "Brand / Manufacturer:", value: "Panasonic")
//                            SpecificationRow(title: "Model Number:", value: "")
//                            SpecificationRow(title: "Serial Number:", value: "")
//                            SpecificationRow(title: "Capacity:", value: "2PK")
//                            SpecificationRow(title: "Power Consumption:", value: "200 Watt")
//                            SpecificationRow(title: "Voltage / Phase:", value: "220V")
//                            SpecificationRow(title: "Refrigerant Type:", value: "R32")
//                            SpecificationRow(title: "Cooling Area Coverage:", value: "50m2")
//                        }
                        VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(equipment.spesifikasi.keys.sorted().filter { $0 != "xPosition" && $0 != "yPosition" }), id: \.self) { key in
                                    if let value = equipment.spesifikasi[key], !value.isEmpty {
                                        SpecificationRow(title: "\(key):", value: value)
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    // History Card Button
                    Button(action: {
                        // Action untuk history card
                    }) {
                        Text("Cek History Card")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("darkblue"))
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
