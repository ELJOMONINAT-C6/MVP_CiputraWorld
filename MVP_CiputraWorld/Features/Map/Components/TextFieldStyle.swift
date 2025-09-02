//
//  TextFieldStyles.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 02/09/25.
//

import SwiftUI

struct AttributeNameTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .font(.system(size: 14, weight: .medium))
    }
}

struct RequiredTextFieldStyle: TextFieldStyle {
    let isEmpty: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEmpty ? Color.red : Color(.systemGray4), lineWidth: isEmpty ? 2 : 1)
            )
            .font(.system(size: 16))
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .font(.system(size: 16))
    }
}
