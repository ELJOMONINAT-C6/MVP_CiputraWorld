//
//  StatusBadge.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//


import SwiftUI

// MARK: - Status Badge
struct StatusBadge: View {
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isActive ? .green : .red)
                .frame(width: 8, height: 8)
            Text(isActive ? "Aktif" : "Tidak Aktif")
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isActive ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .padding(.vertical, 2)
    }
}