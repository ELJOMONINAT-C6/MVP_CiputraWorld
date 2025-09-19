//
//  HistoryDetailView.swift
//  MVP_CiputraWorld
//
//  Created by Kezia Elice on 01/09/25.
//

import SwiftUI

struct HistoryDetailView: View {
    let history: HistoryItem
    var onFinish: (() -> Void)? = nil  // callback untuk tombol Selesai
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Foto header full width
                    if let photoURL = history.photoURL, !photoURL.isEmpty {
                        AsyncImage(url: URL(string: photoURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 400)
                                .frame(height: 250)
                                .clipped()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 400)
                                .frame(height: 250)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.1))
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 400)
                            .frame(height: 250)
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.1))
                    }
                    
                    // Card detail konsisten padding kiri-kanan
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(history.details)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text(history.maintenanceDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Nama Teknisi: \(history.technician)")
                                .font(.subheadline)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Status Unit: \(history.status)")
                                .font(.subheadline)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            dynamicLayout {
                                Text("Status Supervisor:")
                                Text(history.spvStatus)
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                            
                            dynamicLayout {
                                Text("Head of Department Status:")
                                Text(history.hodStatus)
                                    .foregroundColor(.red)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                            
                            Text("Keterangan: \(history.notes ?? "Tidak ada")")
                                .font(.subheadline)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding() // isi dalam card
                        .frame(maxWidth: 400, alignment: .leading)
//                        .background(Color(uiColor: .secondarySystemBackground))
//                        .cornerRadius(16)
//                        .shadow(radius: 4)
                    }
                    .padding(.horizontal, 16) // ✅ konsisten batas kiri-kanan
                    .padding(.top, 16)        // jarak atas dari foto
                }
            }
            
            .navigationTitle("Detail Riwayat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                // Tombol kembali
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Kembali")
//                        }
//                    }
//                }
                
                // Tombol selesai
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Selesai") {
                        dismiss()       // tutup detail
                        onFinish?()     // jalankan callback untuk tutup HistoryListView juga
                    }
                }
            }
        }
    }
}

// Helper untuk dynamic layout (horizontal/vertical adaptif)
@ViewBuilder
func dynamicLayout<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if UIDevice.current.userInterfaceIdiom == .phone {
        HStack(spacing: 4) {
            content()
        }
    } else {
        HStack {
            content()
        }
    }
}
