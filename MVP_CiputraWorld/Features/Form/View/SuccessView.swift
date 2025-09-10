//
//  SuccessView.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 08/09/2025.
//

import SwiftUI

struct SuccessView: View {
    let machine: String
    let date: Date
    let details: String
    let notes: String?
    let status: String
    let technician: String
    let image: UIImage?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Data Submitted")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 12) {
                    
                    // Machine
                    fieldLabel("Machine")
                    DisabledField(text: machine)

                    // Nama Teknisi
                    fieldLabel("Nama Teknisi")
                    DisabledField(text: technician)

                    // Maintenance Details
                    fieldLabel("Maintenance Details")
                    DisabledTextEditor(text: details)

                    // Maintenance Status
                    fieldLabel("Maintenance Status")
                    DisabledField(text: status)

                    // Additional Notes
                    fieldLabel("Additional Notes (Optional)")
                    DisabledTextEditor(text: notes ?? "")

                    // Tanggal
                    fieldLabel("Tanggal")
                    DisabledField(text: date.formatted(date: .abbreviated, time: .omitted))
                    
                    // Foto
                    if let img = image {
                        fieldLabel("Foto")
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3))
                )

                Spacer(minLength: 24)

                // Proceed Button
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Proceed")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 94/255, green: 92/255, blue: 230/255)) // sama kayak tombol "Ambil Gambar"
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
    }
}

#Preview {
    SuccessView(
        machine: "AC-Unit-01",
        date: Date(),
        details: "Perlu pengecekan filter udara.",
        notes: "Filter agak kotor, perlu dibersihkan.",
        status: "Pending",
        technician: "Nathan Gunawan",
        image: UIImage(systemName: "wrench.and.screwdriver")
    )
}

// Disabled TextField-style View
struct DisabledField: View {
    let text: String
    var body: some View {
        Text(text.isEmpty ? "-" : text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
}

// Disabled TextEditor-style View
struct DisabledTextEditor: View {
    let text: String
    var body: some View {
        Text(text.isEmpty ? "-" : text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(minHeight: 80, alignment: .topLeading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
}
