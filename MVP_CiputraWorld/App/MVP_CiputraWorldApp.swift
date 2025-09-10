//
//  MVP_CiputraWorldApp.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 20/08/25.
//

import SwiftUI

@main
struct MVP_CiputraWorldApp: App {
    @StateObject private var viewModel = EquipmentFilteringViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
