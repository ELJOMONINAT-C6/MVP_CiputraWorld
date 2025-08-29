//
//  BasementView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 28/08/25.
//

import SwiftUI

struct BasementView: View {
    var body: some View {
        VStack {
            // Search bar sederhana
            TextField("Cari equipment...", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Area denah - placeholder dulu
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Text("Area Denah")
                        .font(.title)
                        .foregroundColor(.gray)
                )
        }
    }
}
