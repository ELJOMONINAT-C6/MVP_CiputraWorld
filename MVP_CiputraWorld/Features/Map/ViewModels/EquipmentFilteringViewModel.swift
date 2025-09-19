//
//  EquipmentFilteringViewModel.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import Combine

@MainActor
class EquipmentFilteringViewModel: ObservableObject {
    @Published var equipments: [Equipment] = []
    @Published var filteredEquipment: [Equipment] = []
    @Published var searchText: String = "" {
        didSet {
            filterEquipment()
        }
    }
    
    @Published var selectedCategory: String? = nil {
        didSet {
            filterEquipment()
        }
    }
    
    @Published var selectedEquipment: Equipment?  // Ganti sampleEquipment ke Equipment
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await loadEquipments()  // Ambil data dari Supabase
        }
    }
    
    // Ambil data dari Supabase
    private func loadEquipments() async {
        do {
            self.equipments = try await SupabaseManager.shared.fetchEquipment()
            filterEquipment()  // Filter data yang sudah di-fetch
        } catch {
            print("Error fetching equipments: \(error)")
        }
    }
    
    // Filter berdasarkan pencarian dan kategori
    private func filterEquipment() {
        let allEquipment = equipments
        
        // Filter berdasarkan category dan search text
        filteredEquipment = allEquipment.filter { equipment in
            var matchesCategory = true
            var matchesSearch = true
            
            // Filter by category jika ada yang dipilih
            if let category = selectedCategory {
                matchesCategory = equipment.equipmentType == category
            }
            
            // Filter by search text jika tidak kosong
            if !searchText.isEmpty {
                matchesSearch = equipment.assetID.localizedCaseInsensitiveContains(searchText) ||
                equipment.assetName.localizedCaseInsensitiveContains(searchText)
            }
            
            return matchesCategory && matchesSearch
        }
    }
    
//    init(equipments: Equipment) {
//        self.equipments = Equipment
//        setupBindings()
//        filterEquipment()
//    }

    private func setupBindings() {
        // Observe perubahan data di EquipmentStore
//        equipmentStore.$equipments
//            .sink { [weak self] _ in
//                self?.filterEquipment()
//            }
//            .store(in: &cancellables)
        
        // Debounce search biar nggak berat
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterEquipment()
            }
            .store(in: &cancellables)
    }
    
    func selectEquipment(_ equipment: Equipment) {  // Ganti sampleEquipment ke Equipment
        selectedEquipment = equipment
        searchText = equipment.assetID
    }
    
    func selectCategory(_ category: String) {
        if selectedCategory == category {
            // Jika category yang sama diklik lagi, deselect (clear filter)
            selectedCategory = nil
        } else {
            // Pilih category baru
            selectedCategory = category
            searchText = ""
        }
    }
    
    func clearSelection() {
        selectedEquipment = nil
        selectedCategory = nil
        searchText = ""
    }
}
    



