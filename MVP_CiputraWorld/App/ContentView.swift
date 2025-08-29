//
//  ContentView.swift
//  explore-map
//
//  Created by Niken Larasati on 22/08/25.
//

import SwiftUI

struct ContentView: View {
    
    //for styling tab bar
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "darkblue")
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                LandingPageView()
            }
            .tabItem {
                Label("Denah", systemImage: "map")
            }

            NavigationStack {
               MapView()
            }
            .tabItem {
                Label("Tambah", systemImage: "plus")
            }

            NavigationStack {
                MapView()
            }
            .tabItem {
                Label("Riwayat", systemImage: "note")
            }
        }
    }
}

#Preview {
    ContentView()
}
