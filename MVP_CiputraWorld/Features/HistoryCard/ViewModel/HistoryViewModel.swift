//
//  HistoryViewModel.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 01/09/25.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var histories: [HistoryItem2] = []

    init() {
        let calendar = Calendar.current
        
        //    Dummy
        histories = [
            HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 17))!),
            HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 27))!),
            HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 29))!),
            HistoryItem2(title: "Service Outdoor", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 1))!),
            HistoryItem2(title: "Pengecekan Rutin", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 23))!),
            HistoryItem2(title: "Cuci AC", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 13))!),
            HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 20))!),
            HistoryItem2(title: "Service Indoor", date: calendar.date(from: DateComponents(year: 2025, month: 11, day: 12))!)
        ]
    }
}
