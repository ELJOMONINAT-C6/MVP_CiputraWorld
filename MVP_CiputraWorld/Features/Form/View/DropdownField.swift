//
//  DropdownField.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 12/09/25.
//

import SwiftUI

struct DropdownField: View {
    let title: String
    @Binding var selected: String
    let options: [String]
    let isRequired: Bool
    let showValidationError: Bool
    
    @State private var isOpen = false
    
    // Convenience initializer untuk backward compatibility
    init(title: String, selected: Binding<String>, options: [String]) {
        self.title = title
        self._selected = selected
        self.options = options
        self.isRequired = false
        self.showValidationError = false
    }
    
    // Full initializer dengan semua parameter
    init(title: String, selected: Binding<String>, options: [String], isRequired: Bool, showValidationError: Bool) {
        self.title = title
        self._selected = selected
        self.options = options
        self.isRequired = isRequired
        self.showValidationError = showValidationError
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen.toggle()
                }
            }) {
                HStack {
                    Text(selected.isEmpty ? "Pilih \(title)" : selected)
                        .foregroundColor(selected.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isOpen)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(showValidationError && selected.isEmpty ? Color.red : Color.gray.opacity(0.4))
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selected = option
                                isOpen = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selected == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.clear)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if option != options.last {
                            Divider()
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemBackground)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            if showValidationError && selected.isEmpty && isRequired {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Field ini wajib diisi")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
    }
}
