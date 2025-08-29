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
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Denah")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Search
                Search(text: "")
                
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
                .padding(.top, 20)
            }
            .sheet(isPresented: $showingMap) {
                MapView(floorName: selectedFloor)
            }
        }
    }
}

#Preview {
    LandingPageView()
}
