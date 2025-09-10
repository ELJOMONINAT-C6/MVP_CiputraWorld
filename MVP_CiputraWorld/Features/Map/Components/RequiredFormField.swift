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
                    .font(.body.weight(.regular))
                    .foregroundColor(.primary)
                Text("*")
                    .foregroundColor(.red)
                    .font(.body.weight(.medium))
                Spacer()
            }
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .font(.body)
                    .foregroundColor(.gray)
            )
            .font(.body)
            .textFieldStyle(
                RequiredTextFieldStyle(isEmpty: isEmpty && showValidationError)
            )
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
                if attribute.isCompleted {
                    Text(attribute.key.isEmpty ? "-" : attribute.key)
                        .font(.body.weight(.regular))
                        .foregroundColor(.primary)
                } else {
//                    TextField("Nama Atribut (contoh: Brand, Model, dll)", text: $attribute.key)
//                        .font(.body)
//                        .foregroundColor(.primary)
//                        .textFieldStyle(AttributeNameTextFieldStyle())
                    
                    TextField(
                        "",
                        text: $attribute.key,
                        prompt: Text("Nama Atribut (contoh: Brand, Model, dll)")
                            .font(.body)
                            .foregroundColor(.gray)
//                        axis: .vertical
                    )
                    .textFieldStyle(AttributeNameTextFieldStyle())
                    .font(.body)

                }
                
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                }
            }
            
            TextField(
                "",
                text: $attribute.value,
                prompt: Text("Value")
                    .font(.body)
                    .foregroundColor(.gray)
            )
            .textFieldStyle(CustomTextFieldStyle())
            .font(.body)


        }
        .padding(.vertical, 4)
    }
}



// MARK: - Specification Section Component
struct SpecificationSection: View {
    @Binding var customAttributes: [CustomAttribute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Spesifikasi")
                .font(.body.weight(.bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(customAttributes.indices, id: \.self) { index in
                CustomAttributeRow(
                    attribute: $customAttributes[index],
                    onRemove: { removeAttribute(at: index) }
                )
            }
            
            if customAttributes.isEmpty {
                Text("Tap tombol + untuk menambahkan atribut spesifikasi")
                    .foregroundColor(.gray)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            }
            
            Button(action: addNewAttribute) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func addNewAttribute() {
        if let last = customAttributes.last, !last.isCompleted {
            if !last.key.isEmpty && !last.value.isEmpty {
                if let index = customAttributes.firstIndex(where: { $0.id == last.id }) {
                    customAttributes[index].isCompleted = true
                }
                customAttributes.append(CustomAttribute())
            }
        } else {
            customAttributes.append(CustomAttribute())
        }
    }
    
    private func removeAttribute(at index: Int) {
        customAttributes.remove(at: index)
    }
}

