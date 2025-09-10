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
    @State private var maintenanceStatus: String = ""
    @State private var technicianName: String = ""
    
    @State private var showValidationErrors = false
    @State private var navigateToCamera = false
    
    let machines = ["Machine A", "Machine B", "Machine C", "Machine D"]
    let statuses = ["Rusak", "Maintenance Selesai"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // FORM CARD wrapped in ZStack
                    ZStack {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // Machine Picker
                            // Machine Picker
                            inputField(title: "Machine") {
                                FloatingDropdown(
                                    title: "Select Machine",
                                    selected: $selectedMachine,
                                    options: machines
                                )
                            }
                            .zIndex(2) // 🔑 ensures dropdown is above other fields
                            if showValidationErrors && selectedMachine.isEmpty {
                                validationMessage("Please select a machine")
                            }
                            
                            // Technician Name
                            inputField(title: "Nama Teknisi") {
                                TextField("Enter technician name", text: $technicianName)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            if showValidationErrors && technicianName.isEmpty {
                                validationMessage("Please enter technician name")
                            }
                            
                            // Maintenance Details
                            inputField(title: "Maintenance Details") {
                                TextEditor(text: $maintenanceDetails)
                                    .frame(height: 80)
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            if showValidationErrors && maintenanceDetails.isEmpty {
                                validationMessage("Please enter details")
                            }
                            
                            // Status Selection
                            // Status Selection
                            inputField(title: "Maintenance Status") {
                                FloatingDropdown(
                                    title: "Select Status",
                                    selected: $maintenanceStatus,
                                    options: statuses
                                )
                            }
                            .zIndex(1) // slightly lower, so Machine dropdown can float above if both are open
                            if showValidationErrors && maintenanceStatus.isEmpty {
                                validationMessage("Please select maintenance status")
                            }
                            
                            // Additional Notes
                            inputField(title: "Additional Notes (Optional)") {
                                TextEditor(text: $additionalNotes)
                                    .frame(height: 60)
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                            }
                            
                            // Date Picker
                            inputField(title: "Tanggal") {
                                DatePicker("", selection: $maintenanceDate, displayedComponents: .date)
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
                    .zIndex(1) // form layer
                    
                    // SUBMIT BUTTON
                    Button(action: handleAmbilGambar) {
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
                .navigationTitle("Input Form")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        HStack {
//                            Text("Input Form")
//                                .font(.system(size: 24, weight: .bold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            Spacer()
//                        }
//                    }
//                }
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
                    ) { EmptyView() }
                        .hidden()
                )
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

// MARK: - Floating Dropdown Component
struct FloatingDropdown: View {
    let title: String
    @Binding var selected: String
    let options: [String]
    
    @State private var isOpen = false
    
    var body: some View {
        ZStack {
            Button(action: { withAnimation { isOpen.toggle() } }) {
                HStack() {
                    Text(selected.isEmpty ? title : selected)
                        .foregroundColor(selected == "Rusak" ? .red : .primary)
                        .lineLimit(nil)
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                        .background(Color(.secondarySystemBackground))
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
                                    .lineLimit(nil)
                                    .frame(alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                if selected == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
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

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .modelContainer(for: HistoryItem.self, inMemory: true)
    }
}
