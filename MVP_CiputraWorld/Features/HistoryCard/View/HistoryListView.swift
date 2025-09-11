//
//  HistoryListView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

struct HistoryListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = HistoryViewModel()
    
    let equipmentID: UUID
    let equipmentName: String
    let startDate: Date?
    let endDate: Date?
    
    // Convenience initializer untuk semua history (tanpa filter tanggal)
    init(equipmentID: UUID, equipmentName: String) {
        self.equipmentID = equipmentID
        self.equipmentName = equipmentName
        self.startDate = nil
        self.endDate = nil
    }
    
    // Full initializer dengan date filtering
    init(equipmentID: UUID, equipmentName: String, startDate: Date, endDate: Date) {
        self.equipmentID = equipmentID
        self.equipmentName = equipmentName
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var body: some View {
        List(viewModel.histories) { history in
            NavigationLink {
                HistoryDetailView(history: history)
            } label: {
                HStack {
                    Text(history.details)
                        .font(.body)
                    Spacer()
                    Text(history.maintenanceDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            Task {
                if let startDate = startDate, let endDate = endDate {
                    // Dengan filter tanggal
                    await viewModel.fetchHistory(
                        equipmentID: equipmentID,
                        startDate: startDate,
                        endDate: endDate
                    )
                } else {
                    // Tanpa filter tanggal - ambil semua history
                    await viewModel.fetchAllHistory(equipmentID: equipmentID)
                }
            }
        }
        .navigationTitle("History - \(equipmentName)")
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

//struct HistoryListView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel = HistoryViewModel1()
//
//    let category: Category
//    let kodeAlat: String
//    let startDate: Date
//    let endDate: Date
//
//    var body: some View {
//        List(viewModel.histories) { history in
//            NavigationLink {
//                HistoryDetailView(history: history)
//            } label: {
//                HStack {
//                    Text(history.title)
//                        .font(.body)
//                    Spacer()
//                    Text(history.date.formatted(date: .abbreviated, time: .omitted))
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.vertical, 4)
//            }
//        }
//        .navigationTitle("History")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                HStack {
//                    Image(systemName: "chevron.left")
//                    Text("Back")
//                }
//                .foregroundColor(.accentColor)
//                .onTapGesture {
//                    dismiss()
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    HistoryListView(category: .ac,
//                    kodeAlat: "AC0102",
//                    startDate: Date(),
//                    endDate: Date())
//}
