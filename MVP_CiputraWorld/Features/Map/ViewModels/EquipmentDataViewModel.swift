//
//  EquipmentDataViewModel.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import SwiftUI

@MainActor
class EquipmentDataViewModel: ObservableObject {
    @Published var equipments: [sampleEquipment] = []
    private let filename = "equipment.json"
    
    init() {
        load()
    }
    
    func add(_ item: sampleEquipment) {
        equipments.append(item)
        save()
    }
    
    func update(_ item: sampleEquipment) {
        if let idx = equipments.firstIndex(where: { $0.assetID == item.assetID }) {
            equipments[idx] = item
            save()
        }
    }
    
    func remove(_ item: sampleEquipment) {
        equipments.removeAll { $0.assetID == item.assetID }
        save()
    }
    
    func search(by keyword: String) -> [sampleEquipment] {
        equipments.filter {
            keyword.isEmpty ||
            $0.assetName.localizedCaseInsensitiveContains(keyword) ||
            $0.assetID.localizedCaseInsensitiveContains(keyword)
        }
    }
    
    private func documentsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
        
    private func save() {
        let url = documentsURL().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(equipments)
            try data.write(to: url)
        } catch {
            print("Save error:", error)
        }
    }
    
    private func load() {
        let url = documentsURL().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else {
            equipments = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            equipments = try JSONDecoder().decode([sampleEquipment].self, from: data)
        } catch {
            print("Load error:", error)
            equipments = []
        }
    }
}
