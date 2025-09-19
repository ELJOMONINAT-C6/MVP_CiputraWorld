//
//  ContentView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 22/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    //for styling tab bar & navigation bar
    init() {
        // Tab Bar Appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.systemBackground
        tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.label
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        // Navigation Bar Appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(.backgroundClr)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.backgroundClr)]
       
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LandingPageView()
            .tabItem {
                Label("Denah", systemImage: "map")
            }

            InputView()
            .tabItem {
                Label("Maintenance", systemImage: "plus")
            }

            HistoryView()
            .tabItem {
                Label("Riwayat", systemImage: "note")
            }
        }
        .tint(Color.backgroundClr)
    }
}

#Preview {
    ContentView()
        .environmentObject(EquipmentFilteringViewModel())
}
