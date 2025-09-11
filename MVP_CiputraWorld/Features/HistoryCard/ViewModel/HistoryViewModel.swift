//
//  HistoryViewModel.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 01/09/25.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var histories: [HistoryItem] = []
    @Published var equipments: [Equipment] = []
    @Published var selectedEquipmentID: String = ""
        
    // Fungsi untuk mengambil data peralatan dari Supabase
    func fetchEquipments() async {
        do {
            // Ambil data peralatan dari Supabase
            let fetchedEquipments = try await SupabaseManager.shared.fetchEquipment()
            await MainActor.run {
                self.equipments = fetchedEquipments
            }
        } catch {
            print("Error fetching equipment: \(error)")
        }
    }
    
    // Fungsi untuk mengambil history dengan filter tanggal
    func fetchHistory(equipmentID: UUID, startDate: Date, endDate: Date) async {
        do {
            let fetchedHistories = try await SupabaseManager.shared.fetchHistoryItems(
                equipmentID: equipmentID,
                startDate: startDate,
                endDate: endDate
            )
            await MainActor.run {
                self.histories = fetchedHistories
            }
        } catch {
            print("Error fetching history: \(error)")
        }
    }
    
    // Fungsi baru: mengambil SEMUA history untuk equipment tanpa filter tanggal
    func fetchAllHistory(equipmentID: UUID) async {
        do {
            let fetchedHistories = try await SupabaseManager.shared.fetchAllHistoryItems(
                equipmentID: equipmentID
            )
            await MainActor.run {
                self.histories = fetchedHistories.sorted { $0.maintenanceDate > $1.maintenanceDate } // Sort by date descending
            }
        } catch {
            print("Error fetching all history: \(error)")
        }
    }
}

//import Foundation
//
//class HistoryViewModel1: ObservableObject {
//    @Published var histories: [HistoryItem2] = []
//
//    init() {
//        let calendar = Calendar.current
//
//        //    Dummy
//        histories = [
//            HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 17))!),
//            HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 27))!),
//            HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 29))!),
//            HistoryItem2(title: "Service Outdoor", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 1))!),
//            HistoryItem2(title: "Pengecekan Rutin", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 23))!),
//            HistoryItem2(title: "Cuci AC", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 13))!),
//            HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 20))!),
//            HistoryItem2(title: "Service Indoor", date: calendar.date(from: DateComponents(year: 2025, month: 11, day: 12))!)
//        ]
//    }
//}
