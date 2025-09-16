//
//  MapView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import SwiftUI

struct MapView: View {
    @StateObject private var mapViewModel: EquipmentFilteringViewModel
    
    @State private var mapScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var mapOffset: CGSize = .zero
    @State private var showingSearchResults = false
    
    @Environment(\.dismiss) var dismiss
    
    let floorName: String
    
    init(floorName: String, mapViewModel: EquipmentFilteringViewModel) {
        self.floorName = floorName
        _mapViewModel = StateObject(wrappedValue: mapViewModel)
    }
    
    private var searchResults: [Equipment] {
        if mapViewModel.searchText.isEmpty {
            return []
        }
        return mapViewModel.filteredEquipment
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    ZStack {
                        Image("map")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(mapScale)
                            .offset(mapOffset)
                        
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
                                .accessibilityHint("Tap here to see the details of \(equipment.assetName) with ID \(equipment.assetID)")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .scaleEffect(mapScale)
                            .offset(mapOffset)
                        }
                    }
                    
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                mapScale = lastScale * value
                            }
                            .onEnded { value in
                                lastScale = mapScale
                            }
                    )
                    
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                mapOffset = value.translation
                            }
                    )
                }
                
                CategoryFilterView(mapViewModel: mapViewModel)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    EquipmentListView(
                        equipment: searchResults,
                        searchText: mapViewModel.searchText,
                        onSelect: { selectedEquipment in
                            mapViewModel.selectedEquipment = selectedEquipment
                            showingSearchResults = false
                            mapViewModel.searchText = ""
                        },
                        onDismiss: {
                            showingSearchResults = false
                            mapViewModel.searchText = ""
                        }
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.55)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .navigationTitle(floorName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddItemView().environmentObject(mapViewModel)) {
                    Image(systemName: "plus.square.fill.on.square.fill")
                        .font(.system(size: 20))
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.backgroundClr)
                }
            }
        }
        .searchable(text: $mapViewModel.searchText, prompt: "Cari")
        .onChange(of: mapViewModel.searchText) { _, newValue in
            showingSearchResults = !newValue.isEmpty && !searchResults.isEmpty
        }
        .simultaneousGesture(
             DragGesture()
                 .onEnded { value in
                     if value.startLocation.x < 30 && value.translation.width > 50 {
                         withAnimation {
                             dismiss()
                         }
                     }
                 }
         )
        .background(Color(.secondarySystemBackground))
    }
    
    private func resetMapView() {
        mapScale = 1.0
        mapOffset = .zero
        mapViewModel.clearSelection()
    }
}

#Preview {
    MapView(floorName: "Basement", mapViewModel: EquipmentFilteringViewModel())
}
