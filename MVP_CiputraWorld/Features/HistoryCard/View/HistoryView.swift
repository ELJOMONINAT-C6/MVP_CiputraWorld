////
////  HistoryCardView.swift
////  MVP_CiputraWorld
////
////  Created by Niken Larasati on 10/09/25.
////
//
//import Foundation
//import SwiftUI
//
//// Updated Category enum with equipment categories
//enum EquipmentCategory: String, CaseIterable, Identifiable {
//    case ac = "AC"
//    case ahu = "AHU"
//    case fan = "FAN"
//    case lift = "LIFT"
//    
//    var id: String { self.rawValue }
//    
//    var displayName: String {
//        switch self {
//        case .ac: return "Air Conditioner"
//        case .ahu: return "Air Handling Unit"
//        case .fan: return "Fan"
//        case .lift: return "Lift"
//        }
//    }
//}
//
//@MainActor
//class HistorySearchViewModel: ObservableObject {
//    @Published var equipments: [Equipment] = []
//    @Published var filteredEquipments: [Equipment] = []
//    @Published var selectedCategory: EquipmentCategory = .ac
//    @Published var assetID: String = ""
//    @Published var startDate = Date()
//    @Published var endDate = Date()
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    init() {
//        // Set default end date to today and start date to 30 days ago
//        endDate = Date()
//        startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate) ?? Date()
//    }
//    
//    func loadEquipments() async {
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            equipments = try await SupabaseManager.shared.fetchEquipment()
//            filterEquipmentsByCategory()
//            print("✅ Loaded \(equipments.count) equipments")
//        } catch {
//            errorMessage = "Gagal memuat data equipment: \(error.localizedDescription)"
//            print("❌ Error loading equipments: \(error)")
//        }
//        
//        isLoading = false
//    }
//    
//    func filterEquipmentsByCategory() {
//        filteredEquipments = equipments.filter { equipment in
//            equipment.assetID.uppercased().hasPrefix(selectedCategory.rawValue.uppercased())
//        }
//        
//        // Auto-suggest first equipment if available
//        if let firstEquipment = filteredEquipments.first, assetID.isEmpty {
//            assetID = firstEquipment.assetID
//        }
//    }
//    
//    func onCategoryChanged() {
//        filterEquipmentsByCategory()
//        // Clear asset ID when category changes
//        assetID = ""
//        if let firstEquipment = filteredEquipments.first {
//            assetID = firstEquipment.assetID
//        }
//    }
//    
//    var isFormValid: Bool {
//        !assetID.trimmingCharacters(in: .whitespaces).isEmpty && startDate <= endDate
//    }
//}
//
//struct HistoryView: View {
//    @StateObject private var viewModel = HistorySearchViewModel()
//    @State private var searchHistory = false
//    @State private var showingAlert = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if viewModel.isLoading {
//                    ProgressView("Memuat data equipment...")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else {
//                    Form {
//                        // Equipment Type Section
//                        Section {
//                            Picker("Jenis Alat", selection: $viewModel.selectedCategory) {
//                                ForEach(EquipmentCategory.allCases) { category in
//                                    Text(category.displayName)
//                                        .tag(category)
//                                }
//                            }
//                            .accessibilityHint("Pilih kategori peralatan")
//                            .onChange(of: viewModel.selectedCategory) { _ in
//                                viewModel.onCategoryChanged()
//                            }
//                            
//                            // Asset ID Input with suggestions
//                            VStack(alignment: .leading, spacing: 8) {
//                                HStack {
//                                    Text("Kode Alat")
//                                    Spacer()
//                                    TextField("Masukkan Kode Alat", text: $viewModel.assetID)
//                                        .multilineTextAlignment(.trailing)
//                                        .foregroundStyle(.primary)
//                                        .accessibilityHint("Masukkan kode peralatan")
//                                }
//                                
//                                // Show available equipment suggestions
//                                if !viewModel.filteredEquipments.isEmpty {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("Available equipment:")
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
//                                        
//                                        ScrollView(.horizontal, showsIndicators: false) {
//                                            HStack(spacing: 8) {
//                                                ForEach(viewModel.filteredEquipments.prefix(5), id: \.id) { equipment in
//                                                    Button(equipment.assetID) {
//                                                        viewModel.assetID = equipment.assetID
//                                                    }
//                                                    .font(.caption)
//                                                    .padding(.horizontal, 12)
//                                                    .padding(.vertical, 6)
//                                                    .background(
//                                                        RoundedRectangle(cornerRadius: 12)
//                                                            .fill(viewModel.assetID == equipment.assetID ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
//                                                    )
//                                                    .foregroundColor(viewModel.assetID == equipment.assetID ? .blue : .primary)
//                                                }
//                                            }
//                                            .padding(.horizontal, 2)
//                                        }
//                                    }
//                                    .padding(.top, 4)
//                                }
//                            }
//                        } header: {
//                            Text("JENIS PERALATAN")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        // Date Range Section
//                        Section {
//                            DatePicker(
//                                "Dari tanggal",
//                                selection: $viewModel.startDate,
//                                displayedComponents: [.date]
//                            )
//                            .accessibilityLabel("Tanggal mulai")
//                            .accessibilityHint("Pilih tanggal awal periode pencarian")
//                            
//                            DatePicker(
//                                "Sampai tanggal",
//                                selection: $viewModel.endDate,
//                                displayedComponents: [.date]
//                            )
//                            .accessibilityLabel("Tanggal selesai")
//                            .accessibilityHint("Pilih tanggal akhir periode pencarian")
//                            
//                            // Date range validation
//                            if viewModel.startDate > viewModel.endDate {
//                                HStack {
//                                    Image(systemName: "exclamationmark.triangle.fill")
//                                        .foregroundColor(.orange)
//                                    Text("Tanggal mulai harus sebelum tanggal selesai")
//                                        .font(.caption)
//                                        .foregroundColor(.orange)
//                                }
//                            }
//                        } header: {
//                            Text("PERIODE")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        // Submit Button
//                        Button(action: {
//                            handleSubmit()
//                            searchHistory = true
//                        }) {
//                            Text("Lihat Informasi")
//                                .frame(maxWidth: .infinity)
//                        }
//                        .disabled(!viewModel.isFormValid)
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets())
//                        .accessibilityHint("Tekan untuk mencari history card sesuai filter")
//                    }
//                }
//                
//                if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//            }
//            .navigationTitle("Cari History Card")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationDestination(isPresented: $searchHistory) {
//                HistoryListView(
//                    category: viewModel.selectedCategory.rawValue,
//                    assetID: viewModel.assetID,
//                    startDate: viewModel.startDate,
//                    endDate: viewModel.endDate
//                )
//            }
//            .onAppear {
//                Task {
//                    await viewModel.loadEquipments()
//                }
//            }
//            .alert("Validation Error", isPresented: $showingAlert) {
//                Button("OK", role: .cancel) {}
//            } message: {
//                Text("Please check your input and try again.")
//            }
//        }
//    }
//    
//    private func handleSubmit() {
//        guard viewModel.isFormValid else {
//            showingAlert = true
//            return
//        }
//        
//        print("Submit data: \(viewModel.selectedCategory.rawValue) \(viewModel.assetID) \(viewModel.startDate) to \(viewModel.endDate)")
//    }
//}
//
//#Preview {
//    HistoryView()
//}
