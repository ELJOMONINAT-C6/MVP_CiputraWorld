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
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
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
        
//        TabView {
//            NavigationStack {
//                LandingPageView()
//            }
//            .tabItem {
//                Label("Denah", systemImage: "map")
//            }
//
//            NavigationStack {
//               InputView()
//            }
//            .tabItem {
//                Label("Tambah", systemImage: "plus")
//            }
//
//            NavigationStack {
//                HistoryView()
//            }
//            .tabItem {
//                Label("Riwayat", systemImage: "note")
//            }
//        }
    }
}

#Preview {
    ContentView()
}
