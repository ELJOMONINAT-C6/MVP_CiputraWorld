//
//  SupabaseManager.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 09/09/25.
//

import Foundation
import Supabase
import UIKit

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let supabaseUrl = URL(string: "https://rknwisxpxujmujwnlefb.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJrbndpc3hweHVqbXVqd25sZWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTczOTI0NTEsImV4cCI6MjA3Mjk2ODQ1MX0.FisITCakpca-45yR1sjqSXGBi2I1e3Q69CAzRKM_kpk"
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }
}

extension SupabaseManager {
    func fetchEquipment() async throws -> [Equipment] {
        try await client
            .from("equipments")
            .select()
            .execute()
            .value
    }
    
    func insertEquipment(
        assetID: String,
        assetName: String,
        assetLocation: String,
        assetSpec: [String: String],
        imagePath: String? = nil
    ) async throws {
        let newItem = NewEquipment(
            asset_id: assetID,
            asset_name: assetName,
            asset_location: assetLocation,
            asset_spec: assetSpec,
            image_path: imagePath
        )
        
        try await client
            .from("equipments")
            .insert(newItem)
            .execute()
    }
    
    func uploadImage(data: Data, path: String) async throws {
        try await client.storage
            .from("maintenance-photos")
            .upload(path, data: data)
    }
        
    func insertHistoryItem(item: HistoryItem) async throws -> HistoryItem {
        let insertedItem: [HistoryItem] = try await client
            .from("history_items")
            .insert(item)
            .select()
            .execute()
            .value

        guard let newItem = insertedItem.first else {
            throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Gagal mendapatkan item yang baru dibuat."])
        }
        return newItem
    }
    
    func updateHistoryItemPhoto(id: UUID, photoURL: String) async throws {
        _ = try await client
            .from("history_items")
            .update(["photo_url": photoURL])
            .eq("id", value: id)
            .select()
            .single()
            .execute()
    }
    
    func fetchHistoryItems(equipmentID: UUID, startDate: Date, endDate: Date) async throws -> [HistoryItem] {
        let query = client.from("history_items")
            .select()
            .eq("equipment_id", value: equipmentID)
            .gte("maintenance_date", value: startDate)
            .lte("maintenance_date", value: endDate)

        let response: PostgrestResponse<[HistoryItem]> = try await query.execute()
        return response.value
    }
    
    // Method baru - tanpa filter tanggal (ambil semua history untuk equipment)
    func fetchAllHistoryItems(equipmentID: UUID) async throws -> [HistoryItem] {
        let query = client.from("history_items")
            .select()
            .eq("equipment_id", value: equipmentID)
            .order("maintenance_date", ascending: false) // Sort by date descending

        let response: PostgrestResponse<[HistoryItem]> = try await query.execute()
        return response.value
    }
}
