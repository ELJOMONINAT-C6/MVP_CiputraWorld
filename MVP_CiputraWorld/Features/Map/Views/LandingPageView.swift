//
//  LandingPageView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct LandingPageView: View {
    @State private var showingMap = false
    @State private var selectedFloor = ""
    @StateObject private var equipmentStore = EquipmentStore()
    @StateObject private var equipmentDataViewModel = EquipmentDataViewModel()
    @StateObject private var mapViewModel: EquipmentFilteringViewModel
    
    @State private var showingSearchResults = false
    
    init(floorName: String = "Default Floor") {
        let equipmentVM = EquipmentDataViewModel()
        _mapViewModel = StateObject(wrappedValue: EquipmentFilteringViewModel(equipmentViewModel: equipmentVM))
    }
    
    private var searchResults: [sampleEquipment] {
        if mapViewModel.searchText.isEmpty {
            return []
        }
        return equipmentDataViewModel.equipments.filter { equipment in
            equipment.assetName.localizedCaseInsensitiveContains(mapViewModel.searchText) ||
            equipment.assetID.localizedCaseInsensitiveContains(mapViewModel.searchText) ||
            equipment.equipmentType.localizedCaseInsensitiveContains(mapViewModel.searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if showingSearchResults {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(searchResults, id: \.id) { equipment in
                                EquipmentCardView(equipment: equipment) {
                                    mapViewModel.selectedEquipment = equipment
                                    showingSearchResults = false
                                    mapViewModel.searchText = ""
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            NavigationLink(destination: MapView(floorName: "Basement")) {
                                FloorCard(title: "BASEMENT", imageName: "map")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai LG")) {
                                FloorCard(title: "LANTAI LG", imageName: "map")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai G")) {
                                FloorCard(title: "LANTAI G", imageName: "map")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai 1")) {
                                FloorCard(title: "LANTAI 1", imageName: "map")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai 2")) {
                                FloorCard(title: "LANTAI 2", imageName: "map")
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Denah")
            .searchable(text: $mapViewModel.searchText, prompt: "Cari barang apa?")
            .sheet(isPresented: $showingMap) {
                MapView(floorName: selectedFloor)
            }
            .onAppear {
                if equipmentDataViewModel.equipments.isEmpty {
                    equipmentStore.equipments.forEach { equipmentDataViewModel.add($0) }
                }
            }
            .onChange(of: mapViewModel.searchText) { _, newValue in
                showingSearchResults = !newValue.isEmpty && !searchResults.isEmpty
            }
        }
    }
}

#Preview {
    LandingPageView()
}

