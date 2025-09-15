//
//  LandingPageView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject private var mapViewModel = EquipmentFilteringViewModel()
    
    @State private var showingSearchResults = false
    
    var body: some View {
        NavigationStack {
            Group {
                if showingSearchResults {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(mapViewModel.filteredEquipment, id: \.id) { equipment in
                                NavigationLink(destination: EquipmentDetailView(equipment: equipment)) {
                                    EquipmentCardView(equipment: equipment)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                    .padding(.leading)
                                    .background(Color(.separator))
                            }
                        }
                        .background(Color(.systemBackground))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            NavigationLink(destination: MapView(floorName: "Basement", mapViewModel: mapViewModel)) {
                                FloorCard(title: "BASEMENT")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai LG", mapViewModel: mapViewModel)) {
                                FloorCard(title: "LANTAI LG")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai G", mapViewModel: mapViewModel)) {
                                FloorCard(title: "LANTAI G")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai 1", mapViewModel: mapViewModel)) {
                                FloorCard(title: "LANTAI 1")
                            }
                            
                            NavigationLink(destination: MapView(floorName: "Lantai 2", mapViewModel: mapViewModel)) {
                                FloorCard(title: "LANTAI 2")
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Denah")
            .searchable(text: $mapViewModel.searchText, prompt: "Cari barang apa?")
            .onChange(of: mapViewModel.searchText) { _, newValue in
                showingSearchResults = !newValue.isEmpty
            }
            .background(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    LandingPageView()
}

