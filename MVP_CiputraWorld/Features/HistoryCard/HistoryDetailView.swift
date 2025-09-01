//
//  HistoryDetailView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 01/09/25.
//

import Foundation
import SwiftUI

struct HistoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let history: HistoryItem
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    HistoryDetailView(history: HistoryItem(
        title: "Mengganti Kapasitor",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 1))!
    ))
}
