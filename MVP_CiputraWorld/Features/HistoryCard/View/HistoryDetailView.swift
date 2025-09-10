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
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(alignment: .center))
    }
    
    let history: HistoryItem2
    
    var body: some View {
        ScrollView {
            VStack {
                Image("H01")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(history.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(history.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Nama Teknisi: Suprianto")
                    .font(.subheadline)
                Text("Status Unit: Maintenance Selesai")
                    .font(.subheadline)
                Spacer()
                dynamicLayout {
                    Text("Status Supervisor:")
                    Text("Approved")
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                dynamicLayout {
                    Text("Head of Department Status:")
                    Text("Pending")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                Text("Keterangan: Maintenance AHU-AC 01")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            .padding()
            .shadow(radius: 4)
        }
        .navigationTitle("Informasi Item")
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
    HistoryDetailView(history: HistoryItem2(
        title: "Mengganti Kapasitor",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 1))!
    ))
//    HistoryDetailView()
}
