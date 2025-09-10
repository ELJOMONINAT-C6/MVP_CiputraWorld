//
//  FormViewModel.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 10/09/25.
//

import Foundation
import SwiftUI

@MainActor
class FormViewModel: ObservableObject {
    @Published var equipments: [Equipment] = []
    @Published var selectedEquipmentID: UUID? = nil
    @Published var maintenanceDate: Date = Date()
    @Published var maintenanceDetails: String = ""
    @Published var additionalNotes: String = ""
    @Published var maintenanceStatus: String = ""
    @Published var technicianName: String = ""
    @Published var showValidationErrors = false
    @Published var isLoading = false
    
    var isFormValid: Bool {
        selectedEquipmentID != nil &&
        !maintenanceDetails.isEmpty &&
        !maintenanceStatus.isEmpty &&
        !technicianName.isEmpty
    }
    
    func fetchEquipments() async {
        isLoading = true
        do {
            self.equipments = try await SupabaseManager.shared.fetchEquipment()
        } catch {
            print("Error fetching equipments: \(error)")
        }
        isLoading = false
    }
    
    func createHistoryItemPayload() -> HistoryItem? {
        guard isFormValid, let equipmentID = selectedEquipmentID else {
            return nil
        }
        
        let newHistory = HistoryItem(
            id: UUID(),
            equipmentID: equipmentID,
            maintenanceDate: maintenanceDate,
            details: maintenanceDetails,
            notes: additionalNotes,
            photoURL: nil, // Akan diisi di CameraView
            status: maintenanceStatus,
            technician: technicianName,
            spvStatus: "pending", // Nilai default
            hodStatus: "pending", // Nilai default
            createdAt: Date()
        )
        return newHistory
    }
}
