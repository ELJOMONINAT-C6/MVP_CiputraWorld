//
//  HistoryListView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import SwiftUI

struct HistoryListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = HistoryViewModel()
    @GestureState private var dragOffset: CGFloat = 0
    
    @State private var selectedHistory: HistoryItem?
    
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) :
        AnyLayout(HStackLayout(alignment: .center))
    }
    
    let equipmentID: UUID
    let equipmentName: String
    let startDate: Date?
    let endDate: Date?
    
    init(equipmentID: UUID, equipmentName: String) {
        self.equipmentID = equipmentID
        self.equipmentName = equipmentName
        self.startDate = nil
        self.endDate = nil
    }
    
    init(equipmentID: UUID, equipmentName: String, startDate: Date, endDate: Date) {
        self.equipmentID = equipmentID
        self.equipmentName = equipmentName
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var body: some View {
        List(viewModel.histories) { history in
            Button {
                selectedHistory = history
            } label: {
                dynamicLayout {
                    Text(history.details)
                        .font(.body)
                    Spacer()
                    Text(history.maintenanceDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4) // kasih tinggi saja
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                if let startDate = startDate, let endDate = endDate {
                    await viewModel.fetchHistory(
                        equipmentID: equipmentID,
                        startDate: startDate,
                        endDate: endDate
                    )
                } else {
                    await viewModel.fetchAllHistory(equipmentID: equipmentID)
                }
            }
        }
        .navigationTitle("History - \(equipmentName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Selesai") {
                    dismiss()
                }
                .foregroundColor(.accentColor)
                .fontWeight(.semibold)
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 50 {
                        dismiss()
                    }
                }
        )
        .sheet(item: $selectedHistory) { history in
            NavigationStack {
                HistoryDetailView(history: history)
            }
        }
    }
}
