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
                            inputField(title: "Nama Teknisi") {
                                TextField("Masukkan nama teknisi", text: $viewModel.technicianName)
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
                            inputField(title: "Detail Maintenance") {
                                TextEditor(text: $viewModel.maintenanceDetails)
                                    .frame(height: 80)
                                    .padding(6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.showValidationErrors && viewModel.maintenanceDetails.isEmpty ? Color.red : Color.gray.opacity(0.4))
                                    )
                            }
                            if viewModel.showValidationErrors && viewModel.maintenanceDetails.isEmpty {
                                validationMessage("Masukkan detail maintenance")
                            }
                            
                            // Status Selection - Updated
                            DropdownField(
                                title: "Status Maintenance",
                                selected: $viewModel.maintenanceStatus,
                                options: statuses,
                                isRequired: true,
                                showValidationError: viewModel.showValidationErrors
                            )
                            
                            // Additional Notes
                            inputField(title: "Catatan Tambahan (Opsional)") {
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
                .navigationTitle("Form Maintenance")
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

#Preview {
    InputView()
}
