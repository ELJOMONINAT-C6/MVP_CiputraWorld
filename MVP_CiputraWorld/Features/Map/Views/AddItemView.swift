//
//  AddItemView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 02/09/25.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - State Variables
    @State private var namaItem = ""
    @State private var idBarang = ""
    @State private var kategoriBarang = ""
    @State private var customAttributes: [CustomAttribute] = []
    @State private var showValidationError = false
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !namaItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !idBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !kategoriBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Helper Functions
    private func isFieldEmpty(_ field: String) -> Bool {
        field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func handleSubmit() {
        if !isFormValid {
            showValidationError = true
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        } else {
            showValidationError = false
            print("Form valid, proceeding...")
            print("Custom Attributes: \(customAttributes)")
            // Add your submit logic here
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Form Container
                    VStack(spacing: 20) {
                        // TODO: Add photo section here
                        
                        // Required Fields
                        RequiredFormField(
                            title: "Nama Item",
                            text: $namaItem,
                            placeholder: "Value",
                            isEmpty: isFieldEmpty(namaItem),
                            showValidationError: showValidationError
                        )
                        
                        RequiredFormField(
                            title: "ID Barang",
                            text: $idBarang,
                            placeholder: "Value",
                            isEmpty: isFieldEmpty(idBarang),
                            showValidationError: showValidationError
                        )
                        
                        RequiredFormField(
                            title: "Kategori Barang",
                            text: $kategoriBarang,
                            placeholder: "Value",
                            isEmpty: isFieldEmpty(kategoriBarang),
                            showValidationError: showValidationError
                        )
                        
                        // Specification Section
                        SpecificationSection(customAttributes: $customAttributes)
                    }
                    .padding(16)
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 100)
                    
                    // Submit Button
                    SubmitButton(
                        isFormValid: isFormValid,
                        action: handleSubmit
                    )
                    
                    // Error Message
                    if showValidationError && !isFormValid {
                        ErrorMessage()
                    }
                }
            }
            .navigationTitle("Tambahkan Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Supporting Views
struct SubmitButton: View {
    let isFormValid: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Tambahkan Lokasi")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid ? Color(red: 0.11, green: 0.16, blue: 0.31) : Color.gray)
                .cornerRadius(8)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

struct ErrorMessage: View {
    var body: some View {
        Text("Mohon lengkapi semua field yang wajib diisi (*)")
            .font(.system(size: 14))
            .foregroundColor(.red)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
    }
}

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                Text("Kembali")
                    .font(.system(size: 17))
            }
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    AddItemView()
}
