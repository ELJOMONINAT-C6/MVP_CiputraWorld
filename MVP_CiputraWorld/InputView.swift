//
//  InputView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct InputView: View {
    @Environment(\.modelContext) private var context
    
    @State private var selectedMachine: String = ""
    @State private var maintenanceDate: Date = Date()
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var maintenanceDetails: String = ""
    @State private var additionalNotes: String = ""
    
    @State private var showValidationErrors = false
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    
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
                
                // Photo Proof
                Section(header: Text("Photo Proof")) {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Upload Photo")
                        }
                    }
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                    }
                    if showValidationErrors && selectedImage == nil {
                        validationMessage("Please upload a photo")
                    }
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
                
                // Submit Button
                Section {
                    Button(action: handleSubmit) {
                        HStack {
                            Spacer()
                            Text("Submit")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Add Maintenance")
            .onChange(of: photoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            // Error alert
            .alert("Incomplete Form", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please fill in all required fields before submitting.")
            }
            // Success alert
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your maintenance record has been saved.")
            }
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
    
    // MARK: - Submit Logic
    private func handleSubmit() {
        guard !selectedMachine.isEmpty,
              selectedImage != nil,
              !maintenanceDetails.isEmpty else {
            showValidationErrors = true
            showAlert = true
            return
        }
        
        let newItem = HistoryItem(
            machine: selectedMachine,
            date: maintenanceDate,
            details: maintenanceDetails,
            notes: additionalNotes.isEmpty ? nil : additionalNotes,
            photo: selectedImage
        )
        
        context.insert(newItem)
        do {
            try context.save()
            showSuccessAlert = true
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
        
        // Reset form
        selectedMachine = ""
        maintenanceDate = Date()
        selectedImage = nil
        maintenanceDetails = ""
        additionalNotes = ""
        photoItem = nil
        showValidationErrors = false
    }
}

// MARK: - Preview
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .modelContainer(for: HistoryItem.self, inMemory: true) // Preview only
    }
}
