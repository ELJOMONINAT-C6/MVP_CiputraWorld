//
//  InputView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

import SwiftUI
import SwiftData

struct InputView: View {
    @Environment(\.modelContext) private var context
    
    @State private var selectedMachine: String = ""
    @State private var maintenanceDate: Date = Date()
    @State private var maintenanceDetails: String = ""
    @State private var additionalNotes: String = ""
    
    @State private var showValidationErrors = false
    @State private var navigateToCamera = false
    
    let machines = ["Machine A", "Machine B", "Machine C", "Machine D"]
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Add Maintenance")
            // Navigate to CameraView
            .background(
                NavigationLink(
                    destination: CameraView(
                        machine: selectedMachine,
                        date: maintenanceDate,
                        details: maintenanceDetails,
                        notes: additionalNotes
                    ),
                    isActive: $navigateToCamera
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
    
    // MARK: - Validation Helper
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
    
    // MARK: - Ambil Gambar Logic
    private func handleAmbilGambar() {
        guard !selectedMachine.isEmpty,
              !maintenanceDetails.isEmpty else {
            showValidationErrors = true
            return
        }
        navigateToCamera = true
    }
}

// MARK: - Preview
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .modelContainer(for: HistoryItem.self, inMemory: true) // Preview only
    }
}
