//
//  MaintenanceFormView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 10/09/25.
//

import SwiftUI
import SwiftData
import Supabase

struct InputView: View {
    @StateObject private var viewModel = FormViewModel()
    @State private var navigateToCamera = false
    
    let statuses = ["Rusak", "Maintenance Selesai"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // FORM CARD wrapped in ZStack
                    ZStack {
                        VStack(alignment: .leading, spacing: 16) {
                            // Machine Picker
                            inputField(title: "Machine") {
                                FloatingDropdown(
                                    title: "Select Machine",
                                    selected: Binding(
                                        get: {
                                            if let id = viewModel.selectedEquipmentID {
                                                // Menampilkan assetID, bukan UUID
                                                if let equipment = viewModel.equipments.first(where: { $0.id == id }) {
                                                    return equipment.assetID
                                                }
                                            }
                                            return ""
                                        },
                                        set: { assetID in
                                            if let equipment = viewModel.equipments.first(where: { $0.assetID == assetID }) {
                                                viewModel.selectedEquipmentID = equipment.id
                                            }
                                        }
                                    ),
                                    options: viewModel.equipments.map { $0.assetID }
                                )
                            }
                            .zIndex(2)
                            if viewModel.showValidationErrors && viewModel.selectedEquipmentID == nil {
                                validationMessage("Please select a machine")
                            }
                            
                            // Technician Name
                            inputField(title: "Nama Teknisi") {
                                TextField("Enter technician name", text: $viewModel.technicianName)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            if viewModel.showValidationErrors && viewModel.technicianName.isEmpty {
                                validationMessage("Please enter technician name")
                            }
                            
                            // Maintenance Details
                            inputField(title: "Maintenance Details") {
                                TextEditor(text: $viewModel.maintenanceDetails)
                                    .frame(height: 80)
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            if viewModel.showValidationErrors && viewModel.maintenanceDetails.isEmpty {
                                validationMessage("Please enter details")
                            }
                            
                            // Status Selection
                            inputField(title: "Maintenance Status") {
                                FloatingDropdown(
                                    title: "Select Status",
                                    selected: $viewModel.maintenanceStatus,
                                    options: statuses
                                )
                            }
                            .zIndex(1)
                            if viewModel.showValidationErrors && viewModel.maintenanceStatus.isEmpty {
                                validationMessage("Please select maintenance status")
                            }
                            
                            // Additional Notes
                            inputField(title: "Additional Notes (Optional)") {
                                TextEditor(text: $viewModel.additionalNotes)
                                    .frame(height: 60)
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            
                            // Date Picker
                            inputField(title: "Tanggal") {
                                DatePicker("", selection: $viewModel.maintenanceDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .padding(.horizontal, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                        .padding(.horizontal)
                    }
                    .zIndex(1)
                    
                    // SUBMIT BUTTON
                    Button(action: {
                        if viewModel.isFormValid {
                            navigateToCamera = true
                        } else {
                            viewModel.showValidationErrors = true
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemIndigo).opacity(0.8))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        } else {
                            HStack {
                                Image(systemName: "camera")
                                Text("Ambil Gambar")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemIndigo))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle("Input Form")
                .navigationBarTitleDisplayMode(.inline)
            }
            // Navigasi ke CameraView
            .navigationDestination(isPresented: $navigateToCamera) {
                if let historyItem = viewModel.createHistoryItemPayload() {
                    CameraView(historyItem: historyItem)
                } else {
                    Text("Error: Data formulir tidak lengkap")
                }
            }
            .onAppear {
                viewModel.resetForm()
                Task {
                    await viewModel.fetchEquipments()
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func inputField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            content()
        }
    }
    
    private func validationMessage(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(text)
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

struct FloatingDropdown: View {
    let title: String
    @Binding var selected: String
    let options: [String]

    @State private var isOpen = false

    var body: some View {
        ZStack {
            Button(action: { withAnimation { isOpen.toggle() } }) {
                HStack {
                    Text(selected.isEmpty ? title : selected)
                        .foregroundColor(selected == "Rusak" ? .red : .primary)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                        .background(Color.white)
                )
            }
            .zIndex(1)
        }
        .overlay(alignment: .topLeading) {
            if isOpen {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selected = option
                            withAnimation { isOpen = false }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(option == "Rusak" ? .red : .primary)
                                Spacer()
                                if selected == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(radius: 6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
                .padding(.top, 50)
                .zIndex(1000) // force above textfields
            }
        }
    }
}

#Preview {
    InputView()
}
