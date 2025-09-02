//
//  RequiredFormField.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 02/09/25.
//

import SwiftUI

// MARK: - Required Field Component
struct RequiredFormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isEmpty: Bool
    let showValidationError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                Text("*")
                    .foregroundColor(.red)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RequiredTextFieldStyle(isEmpty: isEmpty && showValidationError))
        }
    }
}

// MARK: - Custom Attribute Row Component
struct CustomAttributeRow: View {
    @Binding var attribute: CustomAttribute
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Nama Atribut (contoh: Brand, Model, dll)", text: $attribute.name)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                    .textFieldStyle(AttributeNameTextFieldStyle())
                
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
            
            TextField("Value", text: $attribute.value)
                .textFieldStyle(CustomTextFieldStyle())
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Specification Section Component
struct SpecificationSection: View {
    @Binding var customAttributes: [CustomAttribute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 16) {
                Text("Spesifikasi")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: addNewAttribute) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Dynamic custom attributes
            ForEach(customAttributes.indices, id: \.self) { index in
                CustomAttributeRow(
                    attribute: $customAttributes[index],
                    onRemove: { removeAttribute(at: index) }
                )
            }
            
            // Placeholder text jika belum ada atribut
            if customAttributes.isEmpty {
                Text("Tap tombol + untuk menambahkan atribut spesifikasi")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            }
        }
    }
    
    private func addNewAttribute() {
        customAttributes.append(CustomAttribute())
    }
    
    private func removeAttribute(at index: Int) {
        customAttributes.remove(at: index)
    }
}
