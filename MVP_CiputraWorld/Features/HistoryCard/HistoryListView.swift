//
//  HistoryListView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

struct HistoryItem2: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

let calendar = Calendar.current

struct HistoryListView: View {
    @Environment(\.dismiss) var dismiss
    
    let category: Category
    let kodeAlat: String
    let startDate: Date
    let endDate: Date

//    Dummy
    let histories: [HistoryItem2] = [
        HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 17))!),
        HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 27))!),
        HistoryItem2(title: "Mengganti Kapasitor", date: calendar.date(from: DateComponents(year: 2025, month: 8, day: 29))!),
        HistoryItem2(title: "Service Outdoor", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 1))!),
        HistoryItem2(title: "Pengecekan Rutin", date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 23))!),
        HistoryItem2(title: "Cuci AC", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 13))!),
        HistoryItem2(title: "Mengisi Freon", date: calendar.date(from: DateComponents(year: 2025, month: 10, day: 20))!),
        HistoryItem2(title: "Service Indoor", date: calendar.date(from: DateComponents(year: 2025, month: 11, day: 12))!)
    ]
    
    var body: some View {
        List(histories) { history in
            NavigationLink {
                HistoryDetailView(history: history)
            } label: {
                HStack {
                    Text(history.title)
                        .font(.body)
                    Spacer()
                    Text(history.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.accentColor)
                .onTapGesture {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    HistoryListView(category: .ac,
                    kodeAlat: "AC0102",
                    startDate: Date(),
                    endDate: Date())
}
