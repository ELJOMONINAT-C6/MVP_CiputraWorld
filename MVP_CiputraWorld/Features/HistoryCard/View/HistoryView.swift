//
//  HistoryView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(alignment: .center))
    }
    
    @State private var selectedEquipmentID: UUID? = nil
    @State private var suggestedEquipment: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchHistory = false
    
    @StateObject private var viewModel = HistoryViewModel()
    
    private var selectedEquipment: Equipment? {
        viewModel.equipments.first { $0.id == selectedEquipmentID }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Picker("Nama Alat", selection: $selectedEquipmentID) {
                            Text("Pilih Peralatan").tag(nil as UUID?)
                            ForEach(viewModel.equipments, id: \.id) { equipment in
                                Text(equipment.assetName)
                                    .tag(equipment.id as UUID?)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .accessibilityHint("Pilih nama alat")
                        .onChange(of: selectedEquipmentID) { _, newValue in
                            // Auto-fill code when the equipment is selected
                            if let equipmentID = newValue,
                               let equipment = viewModel.equipments.first(where: { $0.id == equipmentID }) {
                                suggestedEquipment = equipment.assetID
                            }
                        }
                        
                        dynamicLayout {
                            Text("Kode Alat")
                            Spacer()
                            TextField("Masukkan Kode Alat", text: $suggestedEquipment)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.secondary)
                                .onChange(of: suggestedEquipment) { _, newValue in
                                    syncEquipmentSelection(from: newValue)
                                }
                        }
                        
                    } header: {
                        Text("Peralatan")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        dynamicLayout {
                           Text("Dari tanggal")
                           Spacer()
                           DatePicker(
                               "",
                               selection: $startDate,
                               displayedComponents: [.date]
                           )
                           .labelsHidden()
                           .accessibilityLabel("Tanggal mulai")
                           .accessibilityHint("Pilih tanggal awal periode pencarian")
                       }
                       dynamicLayout {
                           Text("Sampai tanggal")
                           Spacer()
                           DatePicker(
                               "",
                               selection: $endDate,
                               displayedComponents: [.date]
                           )
                           .labelsHidden()
                           .accessibilityLabel("Tanggal selesai")
                           .accessibilityHint("Pilih tanggal akhir periode pencarian")
                       }
                    } header: {
                        Text("Rentang Riwayat")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        handleSubmit()
                    }) {
                        Text("Lihat Informasi")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 35)
                    }
                    .disabled(!isFormValid())
                    .buttonStyle(.borderedProminent)
                    .tint(.backgroundClr)
                    .foregroundColor(.foregroundClr)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .accessibilityHint("Tekan untuk mencari history card sesuai filter")
                }
                .navigationDestination(isPresented: $searchHistory) {
                    if let equipmentID = getValidEquipmentID() {
                        HistoryListView(
                            equipmentID: equipmentID,
                            equipmentName: selectedEquipment?.assetName ?? "Unknown Equipment",
                            startDate: startDate,
                            endDate: endDate
                        )
                    }
                }
            }
            .navigationTitle("Cari History Card")
            .onAppear {
                Task {
                    await viewModel.fetchEquipments()
                }
            }
        }
    }
    
    private func syncEquipmentSelection(from assetID: String) {
        // Cari equipment berdasarkan assetID yang diinput manual
        if let equipment = viewModel.equipments.first(where: { $0.assetID == assetID }) {
            selectedEquipmentID = equipment.id
        } else {
            // Jika tidak ditemukan, clear selection
            selectedEquipmentID = nil
        }
    }
    
    private func isFormValid() -> Bool {
        // Validasi: harus ada equipment yang dipilih atau kode alat yang valid
        return getValidEquipmentID() != nil && startDate <= endDate
    }
    
    private func getValidEquipmentID() -> UUID? {
        // Priority 1: Equipment yang dipilih dari picker
        if let selectedID = selectedEquipmentID {
            return selectedID
        }
        
        // Priority 2: Equipment berdasarkan manual input kode alat
        if !suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty,
           let equipment = viewModel.equipments.first(where: { $0.assetID == suggestedEquipment }) {
            return equipment.id
        }
        
        return nil
    }
    
    private func handleSubmit() {
        guard let equipmentID = getValidEquipmentID() else {
            print("No valid equipment selected")
            return
        }
        
        print("Submit data - Equipment ID: \(equipmentID), Period: \(startDate) to \(endDate)")
        searchHistory = true
    }
}

#Preview {
    HistoryView()
}
