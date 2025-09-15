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
    @FocusState private var isDateFocused: Bool
    
    let statuses = ["Rusak", "Maintenance Selesai"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // FORM CARD
                    VStack {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                DropdownField(
                                    title: "Nama Alat",
                                    selected: Binding(
                                        get: {
                                            if let id = viewModel.selectedEquipmentID {
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
                                    options: viewModel.equipments.map { $0.assetID },
                                    isRequired: true,
                                    showValidationError: viewModel.showValidationErrors
                                )
                            }
                            
                            // Technician Name
                            inputField(title: "Nama Teknisi", isRequired: true) {
                                TextField("Masukkan Nama Teknisi", text: $viewModel.technicianName)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.showValidationErrors && viewModel.technicianName.isEmpty ? Color.red : Color.gray.opacity(0.4))
                                    )
                            }
                            if viewModel.showValidationErrors && viewModel.technicianName.isEmpty {
                                validationMessage("Masukkan nama teknisi")
                            }
                            
                            // Maintenance Details
                            inputField(title: "Detail Maintenance", isRequired: true) {
                                TextEditor(text: $viewModel.maintenanceDetails)
                                    .frame(height: 80)
                                    .padding(6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.showValidationErrors && viewModel.maintenanceDetails.isEmpty ? Color.red : Color.gray.opacity(0.4))
                                    )
                            }
                            if viewModel.showValidationErrors && viewModel.maintenanceDetails.isEmpty {
                                validationMessage("Masukkan Detail Maintenance")
                            }
                            
                            // Status Selection - Updated
                            DropdownField(
                                title: "Status Maintenance",
                                selected: $viewModel.maintenanceStatus,
                                options: statuses,
                                isRequired: true,
                                showValidationError: viewModel.showValidationErrors
                            )
                            
                            // Date Picker
                            HStack {
                                HStack(spacing: 2) {
                                    Text("Tanggal")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("*")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                }
                                Spacer()
                                DatePicker("", selection: $viewModel.maintenanceDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .padding(.horizontal, 8)
                                    .focused($isDateFocused)
                                    .onChange(of: viewModel.maintenanceDate) {
                                        isDateFocused = false
                                    }

                            }
                            .padding(.vertical, 6)

                            
                            // Additional Notes
                            inputField(title: "Catatan Tambahan (Opsional)") {
                                TextEditor(text: $viewModel.additionalNotes)
                                    .frame(height: 60)
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemBackground))
                                .stroke(Color(UIColor.systemFill))
                        )
                        .padding(.horizontal)
                    }
                    
                    // SUBMIT BUTTON
                    Button(action: {
                        if viewModel.isFormValid {
                            navigateToCamera = true
                        } else {
                            viewModel.showValidationErrors = true
                        }
                    }) {
                            HStack {
                                Image(systemName: "camera")
                                Text("Ambil Gambar")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color.foregroundClr)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.backgroundClr)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Form Maintenance")
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
            .background(Color(.secondarySystemBackground))
        }
    }
    
    private func inputField<Content: View>(
        title: String,
        isRequired: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
            }
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

#Preview {
    InputView()
}
