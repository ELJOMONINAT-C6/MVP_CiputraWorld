//
//  ContentView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 22/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    //for styling tab bar
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "darkblue")
        appearance.stackedLayoutAppearance.selected.iconColor = .textClr
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.textClr]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LandingPageView()
            .tabItem {
                Label("Denah", systemImage: "map")
            }

            InputView()
            .tabItem {
                Label("Tambah", systemImage: "plus")
            }

            HistoryView()
            .tabItem {
                Label("Riwayat", systemImage: "note")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EquipmentFilteringViewModel())
}
