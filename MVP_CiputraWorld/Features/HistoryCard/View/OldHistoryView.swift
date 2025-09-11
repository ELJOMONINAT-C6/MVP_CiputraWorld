//
//  HistoryView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @State private var selectedEquipmentID: UUID? = nil
    @State private var suggestedEquipment: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchHistory = false
    
    @StateObject private var viewModel = HistoryViewModel()
    
    // Computed property untuk mendapatkan equipment yang dipilih
    private var selectedEquipment: Equipment? {
        viewModel.equipments.first { $0.id == selectedEquipmentID }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        // Simplified Picker dengan UUID selection
                        Picker("Jenis Alat", selection: $selectedEquipmentID) {
                            Text("Pilih Peralatan").tag(nil as UUID?)
                            ForEach(viewModel.equipments, id: \.id) { equipment in
                                Text(equipment.assetName)
                                    .tag(equipment.id as UUID?)
                            }
                        }
                        .onChange(of: selectedEquipmentID) { _, newValue in
                            // Auto-fill kode alat saat equipment dipilih
                            if let equipmentID = newValue,
                               let equipment = viewModel.equipments.first(where: { $0.id == equipmentID }) {
                                suggestedEquipment = equipment.assetID
                            }
                        }
                        
                        HStack {
                            Text("Kode Alat")
                            Spacer()
                            TextField("Masukkan Kode Alat", text: $suggestedEquipment)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.secondary)
                                .onChange(of: suggestedEquipment) { _, newValue in
                                    // Sync selection jika user manual input kode alat
                                    syncEquipmentSelection(from: newValue)
                                }
                        }
                    } header: {
                        Text("JENIS PERALATAN")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        DatePicker(
                            "Dari tanggal",
                            selection: $startDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            "Sampai tanggal",
                            selection: $endDate,
                            displayedComponents: [.date]
                        )
                    } header: {
                        Text("PERIODE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        handleSubmit()
                    }) {
                        Text("Lihat Informasi")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isFormValid())
                    .buttonStyle(.borderedProminent)
                    .tint(.interactiveClr)
                    .foregroundColor(.textClr)
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
    
    // MARK: - Helper Methods
    
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



//enum Category: String, CaseIterable, Identifiable {
//    case ac = "Air Conditioner"
//    case ahu = "AHU"
//
//    var id: String { self.rawValue }
//}
//
//enum Equipment2: String, CaseIterable, Identifiable {
//    case AC0102, AHU0101
//    var id: Self { self }
//}
//
//
//extension Category {
//    var suggestedEquipment: Equipment2 {
//        switch self {
//        case .ac: return .AC0102
//        case .ahu: return .AHU0101
//        }
//    }
//}
//
//struct HistoryView: View {
//    @State private var selectedCategory: Category = .ac
//    @State private var suggestedEquipment: String = Category.ac.suggestedEquipment.rawValue
//    @State private var startDate = Date()
//    @State private var endDate = Date()
//    @State private var searchHistory = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    Section {
//                        Picker("Jenis Alat", selection: $selectedCategory) {
//                            ForEach(Category.allCases) { category in
//                                Text(category.rawValue)
//                                    .tag(category)
//                            }
//                        }
//                        .accessibilityHint("Pilih kategori peralatan")
//                        .onChange(of: selectedCategory) { newValue in
//                            suggestedEquipment = newValue.suggestedEquipment.rawValue
//                        }
//                        HStack {
//                            Text("Kode Alat")
//                            Spacer()
//                            TextField("Masukkan Kode Alat", text: $suggestedEquipment)
//                                .multilineTextAlignment(.trailing)
//                                .foregroundStyle(.secondary)
//                                .accessibilityHint("Masukkan kode peralatan secara manual")
//                        }
//                    } header: {
//                        Text("JENIS PERALATAN")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    Section {
//                        DatePicker(
//                            "Dari tanggal",
//                            selection: $startDate,
//                            displayedComponents: [.date]
//                        )
//                        .accessibilityLabel("Tanggal mulai")
//                        .accessibilityHint("Pilih tanggal awal periode pencarian")
//                        DatePicker(
//                            "Sampai tanggal",
//                            selection: $endDate,
//                            displayedComponents: [.date]
//                        )
//                        .accessibilityLabel("Tanggal selesai")
//                        .accessibilityHint("Pilih tanggal akhir periode pencarian")
//                    } header: {
//                        Text("PERIODE")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    Button(action: {handleSubmit(); searchHistory = true}) {
//                        Text("Lihat Informasi")
//                            .frame(maxWidth: .infinity)
//                    }
//                    .disabled(suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty)
//                    .buttonStyle(.borderedProminent)
//                    .tint(.interactiveClr)
//                    .foregroundColor(.textClr)
//                    .listRowBackground(Color.clear)
//                    .listRowInsets(EdgeInsets())
//                    .accessibilityHint("Tekan untuk mencari history card sesuai filter")
//                }
//                .navigationDestination(isPresented: $searchHistory) {
//                    HistoryListView(
//                        category: selectedCategory,
//                        kodeAlat: suggestedEquipment,
//                        startDate: startDate,
//                        endDate: endDate
//                    )
//                }
//            }
////            .environment(\.locale, Locale(identifier: "id"))
//            .navigationTitle("Cari History Card")
//        }
//    }
//    
//    private func handleSubmit() {
//        guard !suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty else {
//            print("Equipment ID is empty")
//            return
//        }
//        print("Submit data: \(selectedCategory.rawValue) \(suggestedEquipment) \(startDate) to \(endDate)")
//    }
//
//}
//

#Preview {
    HistoryView()
}
