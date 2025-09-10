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

enum Equipment2: String, CaseIterable, Identifiable {
    case AC0102, AHU0101
    var id: Self { self }
}


extension Category {
    var suggestedEquipment: Equipment2 {
        switch self {
        case .ac: return .AC0102
        case .ahu: return .AHU0101
        }
    }
}

struct HistoryView: View {
    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize: DynamicTypeSize
    
    var dynamicLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize ?
        AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(alignment: .center))
    }
    
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
                        .pickerStyle(.navigationLink)
                        .accessibilityHint("Pilih kategori peralatan")
                        .onChange(of: selectedCategory) { newValue in
                            suggestedEquipment = newValue.suggestedEquipment.rawValue
                        }
                        dynamicLayout {
                            Text("Kode Alat")
                            Spacer()
                            TextField("Masukkan Kode Alat", text: $suggestedEquipment)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.secondary)
                                .accessibilityHint("Masukkan kode peralatan secara manual")
                        }
                    } header: {
                        Text("JENIS PERALATAN")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        dynamicLayout {
                            Text("Dari tanggal")
                            Spacer()
                            DatePicker(
                                "",
                                selection: $startDate,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .accessibilityLabel("Tanggal mulai")
                            .accessibilityHint("Pilih tanggal awal periode pencarian")
                        }
                        dynamicLayout {
                            Text("Sampai tanggal")
                            Spacer()
                            DatePicker(
                                "",
                                selection: $endDate,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .accessibilityLabel("Tanggal selesai")
                            .accessibilityHint("Pilih tanggal akhir periode pencarian")
                        }
//                        DatePicker(
//                            "Sampai tanggal",
//                            selection: $endDate,
//                            displayedComponents: [.date]
//                        )
//                        .accessibilityLabel("Tanggal selesai")
//                        .accessibilityHint("Pilih tanggal akhir periode pencarian")
                    } header: {
                        Text("PERIODE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Button(action: {handleSubmit(); searchHistory = true}) {
                        Text("Lihat Informasi")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 35)
                    }
                    .disabled(suggestedEquipment.trimmingCharacters(in: .whitespaces).isEmpty)
                    .buttonStyle(.borderedProminent)
                    .tint(.backgroundClr)
                    .foregroundColor(.foregroundClr)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .accessibilityHint("Tekan untuk mencari history card sesuai filter")
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
//            .environment(\.locale, Locale(identifier: "id"))
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
