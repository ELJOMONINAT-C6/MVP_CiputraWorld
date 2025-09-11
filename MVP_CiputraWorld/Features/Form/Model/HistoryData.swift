//
//  HistoryItem.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

//import SwiftData
import Foundation

struct HistoryItem: Identifiable, Codable {
    let id: UUID?
    let equipmentID: UUID
    let maintenanceDate: Date
    let details: String
    let notes: String?
    var photoURL: String?
    let status: String
    let technician: String
    let spvStatus: String
    let hodStatus: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case equipmentID = "equipment_id"
        case maintenanceDate = "maintenance_date"
        case details
        case notes
        case photoURL = "photo_url"
        case status
        case technician
        case spvStatus = "spv_status"
        case hodStatus = "hod_status"
        case createdAt = "created_at"
    }
    
    init(equipmentID: UUID, maintenanceDate: Date, details: String, notes: String?, status: String, technician: String) {
        self.id = nil
        self.equipmentID = equipmentID
        self.maintenanceDate = maintenanceDate
        self.details = details
        self.notes = notes
        self.photoURL = nil
        self.status = status
        self.technician = technician
        self.spvStatus = "pending"
        self.hodStatus = "pending"
        self.createdAt = Date()
    }
}
