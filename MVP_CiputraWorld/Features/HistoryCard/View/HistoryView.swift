//
//  HistoryView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) :
        AnyLayout(HStackLayout(alignment: .center))
    }
    
    @State private var selectedEquipmentID: UUID? = nil
    @State private var suggestedEquipment: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showHistoryList = false
    
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
                            DatePicker("", selection: $startDate, displayedComponents: [.date])
                                .labelsHidden()
                                .accessibilityLabel("Tanggal mulai")
                        }
                        dynamicLayout {
                            Text("Sampai tanggal")
                            Spacer()
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                                .labelsHidden()
                                .accessibilityLabel("Tanggal selesai")
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
                    .sheet(isPresented: $showHistoryList) {
                        if let equipmentID = getValidEquipmentID() {
                            NavigationStack {
                                HistoryListView(
                                    equipmentID: equipmentID,
                                    equipmentName: selectedEquipment?.assetName ?? "Unknown Equipment",
                                    startDate: startDate,
                                    endDate: endDate
                                )
                            }
                        }
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
        if let equipment = viewModel.equipments.first(where: { $0.assetID == assetID }) {
            selectedEquipmentID = equipment.id
        } else {
            selectedEquipmentID = nil
        }
    }
    
    private func isFormValid() -> Bool {
        return getValidEquipmentID() != nil && startDate <= endDate
    }
    
    private func getValidEquipmentID() -> UUID? {
        if let selectedID = selectedEquipmentID {
            return selectedID
        }
        
        if !suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty,
           let equipment = viewModel.equipments.first(where: { $0.assetID == suggestedEquipment }) {
            return equipment.id
        }
        
        return nil
    }
    
    private func handleSubmit() {
        guard getValidEquipmentID() != nil else {
            print("No valid equipment selected")
            return
        }
        showHistoryList = true
    }
}

#Preview {
    HistoryView()
}
