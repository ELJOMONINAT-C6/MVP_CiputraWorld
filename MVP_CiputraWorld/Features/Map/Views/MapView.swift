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
    
    @State private var showingEquipmentDetail = false
    
    @Environment(\.dismiss) var dismiss
    
    let floorName: String
    
    init(floorName: String = "Default Floor") {
        self.floorName = floorName
        let equipmentVM = EquipmentDataViewModel()
        _equipmentDataViewModel = StateObject(wrappedValue: equipmentVM)
        _mapViewModel = StateObject(wrappedValue: EquipmentFilteringViewModel(equipmentViewModel: equipmentVM))
    }
    
    var body: some View {
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
                        EquipmentPointView(
                            equipment: equipment,
                            geometrySize: geometry.size,
                            isSelected: mapViewModel.selectedEquipment?.assetID == equipment.assetID,
                            onTap: {
                                mapViewModel.selectedEquipment = equipment
                                showingEquipmentDetail = true
                            },
                            mapViewModel: mapViewModel
                        )
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
        
        .sheet(isPresented: $showingEquipmentDetail) {
            if let selectedEquipment = mapViewModel.selectedEquipment {
                EquipmentDetailView(equipment: selectedEquipment)
            }
        }
        
        .onAppear {
            // Load dummy data jika belum ada data
            if equipmentDataViewModel.equipments.isEmpty {
                loadDummyData()
            }
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
