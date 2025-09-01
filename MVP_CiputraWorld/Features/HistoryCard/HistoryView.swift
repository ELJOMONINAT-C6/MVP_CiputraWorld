//
//  HistoryView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 29/08/25.
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case ac = "Air Conditioner"
    case ahu = "AHU"

    var id: String { self.rawValue }
}

enum Equipment: String, CaseIterable, Identifiable {
    case AC0102, AHU0101
    var id: Self { self }
}


extension Category {
    var suggestedEquipment: Equipment {
        switch self {
        case .ac: return .AC0102
        case .ahu: return .AHU0101
        }
    }
}

struct HistoryView: View {
    @State private var selectedCategory: Category = .ac
    @State private var suggestedEquipment: String = Category.ac.suggestedEquipment.rawValue
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var searchHistory = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Picker("Jenis Alat", selection: $selectedCategory) {
                            ForEach(Category.allCases) { category in
                                Text(category.rawValue)
                                    .tag(category)
                            }
                        }
                        .onChange(of: selectedCategory) { newValue in
                            suggestedEquipment = newValue.suggestedEquipment.rawValue
                        }
                        HStack {
                            Text("Kode Alat")
                            Spacer()
                            TextField("Masukkan Kode Alat", text: $suggestedEquipment)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.secondary)
                        }
                    } header: {
                        Text("JENIS PERALATAN")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        DatePicker(
                            "Dari tanggal",
                            selection: $startDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            "Sampai tanggal",
                            selection: $endDate,
                            displayedComponents: [.date]
                        )
                    } header: {
                        Text("PERIODE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Button(action: {handleSubmit(); searchHistory = true}) {
                        Text("Lihat Informasi")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty)
                    .buttonStyle(.borderedProminent)
                    .tint(.interactiveClr)
                    .foregroundColor(.textClr)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                .navigationDestination(isPresented: $searchHistory) {
                    HistoryListView(
                        category: selectedCategory,
                        kodeAlat: suggestedEquipment,
                        startDate: startDate,
                        endDate: endDate
                    )
                }
            }
            .navigationTitle("Cari History Card")
        }
    }
    
    private func handleSubmit() {
        guard !suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Equipment ID is empty")
            return
        }
        print("Submit data: \(selectedCategory.rawValue) \(suggestedEquipment) \(startDate) to \(endDate)")
    }

}

#Preview {
    HistoryView()
}
