//
//  HistoryItem.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

//import SwiftData
import Foundation

/// Model untuk data riwayat maintenance, sesuai tabel `history_items` di Supabase
struct HistoryItem: Identifiable, Codable {
    let id: UUID
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
}

// Model for database

//@Model
//class HistoryItem {
//    @Attribute(.unique) var id: UUID
//
//    var machine: String
//    var date: Date
//    var details: String
//    var notes: String?
//    var photoData: Data?   // store image as Data
//
//    // New fields
//    var status: String
//    var technician: String
//    var spvStatus: String
//    var hodStatus: String
//
//    init(
//        id: UUID = UUID(),
//        machine: String,
//        date: Date,
//        details: String,
//        notes: String? = nil,
//        photoData: Data? = nil,
//        status: String,
//        technician: String,
//        spvStatus: String,
//        hodStatus: String
//    ) {
//        self.id = id
//        self.machine = machine
//        self.date = date
//        self.details = details
//        self.notes = notes
//        self.photoData = photoData
//        self.status = status
//        self.technician = technician
//        self.spvStatus = spvStatus
//        self.hodStatus = hodStatus
//    }
//}
