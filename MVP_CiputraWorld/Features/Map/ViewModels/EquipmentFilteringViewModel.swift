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
    @Published var filteredEquipment: [sampleEquipment] = []  // Menggunakan sampleEquipment
    @Published var searchText: String = "" {
        didSet {
            filterEquipment()
        }
    }
    
    @Published var selectedCategory: String? = nil { // Tambah ini untuk track category yang dipilih
        didSet {
            filterEquipment()
        }
    }
    
    @Published var selectedEquipment: sampleEquipment?  // Menggunakan sampleEquipment
    
    private var equipmentViewModel: EquipmentDataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(equipmentViewModel: EquipmentDataViewModel) {
        self.equipmentViewModel = equipmentViewModel
        setupBindings()
        filterEquipment()
    }
    
    private func setupBindings() {
        // Observe perubahan data di EquipmentViewModel
        equipmentViewModel.$equipments
            .sink { [weak self] _ in
                self?.filterEquipment()
            }
            .store(in: &cancellables)
        
        // Debounce search biar nggak berat
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterEquipment()
            }
            .store(in: &cancellables)
    }
    
    private func filterEquipment() {
        let allEquipment = equipmentViewModel.equipments
        
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
                                equipment.assetName.localizedCaseInsensitiveContains(searchText)  // Menggunakan assetName
            }
            
            return matchesCategory && matchesSearch
        }
    }
    
    func selectEquipment(_ equipment: sampleEquipment) {  // Menggunakan sampleEquipment
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
            searchText = "" // Clear search text ketika pilih category
        }
    }
    
    func clearSelection() {
        selectedEquipment = nil
        selectedCategory = nil
        searchText = ""
    }
}

