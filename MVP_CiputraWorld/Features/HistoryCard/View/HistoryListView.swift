//
//  HistoryListView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

struct HistoryListView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(alignment: .center))
    }
    
    let category: Category
    let kodeAlat: String
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        List(viewModel.histories) { history in
            NavigationLink {
                HistoryDetailView(history: history)
            } label: {
                dynamicLayout {
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
