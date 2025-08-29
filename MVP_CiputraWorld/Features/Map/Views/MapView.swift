//
//  MapView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct MapView: View {
    @StateObject private var equipmentDataViewModel = EquipmentDataViewModel()
    @StateObject private var mapViewModel: EquipmentFilteringViewModel
    
    @State private var mapScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var mapOffset: CGSize = .zero
    
    @State private var showingSearchResults = false
    
    @Environment(\.dismiss) var dismiss
    
    let floorName: String
    
    init(floorName: String = "Default Floor") {
        self.floorName = floorName
        let equipmentVM = EquipmentDataViewModel()
        _equipmentDataViewModel = StateObject(wrappedValue: equipmentVM)
        _mapViewModel = StateObject(wrappedValue: EquipmentFilteringViewModel(equipmentViewModel: equipmentVM))
    }
    
    // Computed property untuk hasil search
        private var searchResults: [Equipment] {
            if mapViewModel.searchText.isEmpty {
                return []
            }
            return equipmentDataViewModel.equipments.filter { equipment in
                equipment.namaAlat.localizedCaseInsensitiveContains(mapViewModel.searchText) ||
                equipment.assetID.localizedCaseInsensitiveContains(mapViewModel.searchText) ||
                equipment.equipmentType.localizedCaseInsensitiveContains(mapViewModel.searchText)
            }
        }

    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                // Map View
                GeometryReader { geometry in
                    ZStack {
                        Image("map")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(mapScale)
                            .offset(mapOffset)
                        
                        // Equipment points overlay
                        ForEach(mapViewModel.filteredEquipment) { equipment in
                            NavigationLink(
                                destination: EquipmentDetailView(equipment: equipment)
                            ) {
                                EquipmentPointView(
                                    equipment: equipment,
                                    geometrySize: geometry.size,
                                    isSelected: mapViewModel.selectedEquipment?.assetID == equipment.assetID,
                                    mapViewModel: mapViewModel
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .scaleEffect(mapScale)
                            .offset(mapOffset)
                        }
                    }
                    // Zoom using 2 fingers
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                mapScale = lastScale * value
                            }
                            .onEnded { value in
                                lastScale = mapScale
                            }
                    )
                    
                    // Drag the map
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                mapOffset = value.translation
                            }
                    )
                }
                
                CategoryFilterView(mapViewModel: mapViewModel)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 8)
                
            }
            
            if showingSearchResults {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingSearchResults = false
                        mapViewModel.searchText = ""
                    }
                
                VStack {
                    Spacer()
                    
                    EquipmentListView(
                        equipment: searchResults,
                        searchText: mapViewModel.searchText,
                        onSelect: { selectedEquipment in
                            mapViewModel.selectedEquipment = selectedEquipment
                            showingSearchResults = false
                            mapViewModel.searchText = ""
                            // Optional: Navigate ke detail
                        },
                        onDismiss: {
                            showingSearchResults = false
                            mapViewModel.searchText = ""
                        }
                    )
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
                }
            }
    }
        .navigationTitle(floorName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                       Image(systemName: "chevron.left")
                       Text("Kembali")
                   }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reset") {
                    resetMapView()
                }
            }
        }
        .searchable(text: $mapViewModel.searchText, prompt: "Cari")
        
//        .sheet(isPresented: $showingEquipmentDetail) {
//            if let selectedEquipment = mapViewModel.selectedEquipment {
//                EquipmentDetailView(equipment: selectedEquipment)
//            }
//        }
        
        .onAppear {
            // Load dummy data jika belum ada data
            if equipmentDataViewModel.equipments.isEmpty {
                loadDummyData()
            }
        }
        .onChange(of: mapViewModel.searchText) { _, newValue in
                    showingSearchResults = !newValue.isEmpty && !searchResults.isEmpty
        }
    }
    
    private func resetMapView() {
        mapScale = 1.0
        mapOffset = .zero
        mapViewModel.clearSelection()
    }
    
    private func loadDummyData() {
        // Load dummy data dari equipmentList yang sudah ada
        for equipment in equipmentList {
            equipmentDataViewModel.add(equipment)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
