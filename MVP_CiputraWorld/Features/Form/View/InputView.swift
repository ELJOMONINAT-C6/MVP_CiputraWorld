//
//  InputView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

import SwiftUI
import SwiftData

// View for Input Form
struct InputView: View {
    @Environment(\.modelContext) private var context
    
    // Defining Variables
    @State private var selectedMachine: String = ""
    @State private var maintenanceDate: Date = Date()
    @State private var maintenanceDetails: String = ""
    @State private var additionalNotes: String = ""
    
    // New fields
    @State private var maintenanceStatus: String = ""
    @State private var technicianName: String = ""
    
    @State private var showValidationErrors = false
    @State private var navigateToCamera = false
    
    let machines = ["Machine A", "Machine B", "Machine C", "Machine D"]
    let statuses = ["Rusak", "Maintenance Selesai"]
    
    
    
    var body: some View {
        NavigationView {
            // Form for Input Data
            Form {
                // Machine Picker
                Section(header: Text("Machine")) {
                    Picker("Select Machine", selection: $selectedMachine) {
                        ForEach(machines, id: \.self) { machine in
                            Text(machine).tag(machine)
                        }
                    }
                    
                    if showValidationErrors && selectedMachine.isEmpty {
                        validationMessage("Please select a machine")
                    }
                }
                
                // Date Picker
                Section(header: Text("Date of Maintenance")) {
                    DatePicker("Select Date", selection: $maintenanceDate, displayedComponents: .date)
                }
                
                // Maintenance Details
                Section(header: Text("Maintenance Details")) {
                    TextEditor(text: $maintenanceDetails)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    if showValidationErrors && maintenanceDetails.isEmpty {
                        validationMessage("Please enter details")
                    }
                }
                
                // Maintenance Status
                Section(header: Text("Maintenance Status")) {
                    Picker("Select Status", selection: $maintenanceStatus) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if showValidationErrors && maintenanceStatus.isEmpty {
                        validationMessage("Please select maintenance status")
                    }
                }
                
                // Technician Name
                Section(header: Text("Nama Teknisi")) {
                    TextField("Enter technician name", text: $technicianName)
                    if showValidationErrors && technicianName.isEmpty {
                        validationMessage("Please enter technician name")
                    }
                }
                
                // Additional Notes
                Section(header: Text("Additional Notes (Optional)")) {
                    TextEditor(text: $additionalNotes)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }
                
                // Ambil Gambar Button
                Section {
                    Button(action: handleAmbilGambar) {
                        HStack {
                            Spacer()
                            Text("Ambil Gambar")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Input Form")
            // Navigate to CameraView
            .background(
                NavigationLink(
                    destination: CameraView(
                        machine: selectedMachine,
                        date: maintenanceDate,
                        details: maintenanceDetails,
                        notes: additionalNotes,
                        status: maintenanceStatus,
                        technician: technicianName
                    ),
                    isActive: $navigateToCamera
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
    
    // Validation Helper
    @ViewBuilder
    private func validationMessage(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(text)
                .foregroundColor(.red)
                .font(.caption)
        }
    }
    
    // Logic for Proceeding to the Next Page
    private func handleAmbilGambar() {
        guard !selectedMachine.isEmpty,
              !maintenanceDetails.isEmpty,
              !maintenanceStatus.isEmpty,
              !technicianName.isEmpty else {
            showValidationErrors = true
            return
        }
        navigateToCamera = true
    }
}

// Preview
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .modelContainer(for: HistoryItem.self, inMemory: true) // Preview only
    }
}
