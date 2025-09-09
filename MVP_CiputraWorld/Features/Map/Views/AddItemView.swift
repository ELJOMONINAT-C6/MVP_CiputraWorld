//
//  AddItemView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 02/09/25.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: EquipmentDataViewModel  // 🔥 Tambahkan ini

    // Form Fields
    @State private var namaItem = ""
    @State private var idBarang = ""
    @State private var lokasiBarang = ""
    @State private var customAttributes: [CustomAttribute] = []
    
    // State
    @State private var showValidationError = false
    @State private var showLocationPicker = false
    @State private var showSuccessAlert = false
    
    // Foto
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    // Lokasi
    @State private var selectedLocation: CGPoint? = nil
    
    private var isFormValid: Bool {
        !namaItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !idBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lokasiBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// 🔥 Fungsi Save Item
    private func handleSave() {
        guard isFormValid else {
            showValidationError = true
            return
        }
        
        // Convert customAttributes ke Dictionary
        var attributesDict = Dictionary(
            uniqueKeysWithValues: customAttributes
                .filter { !$0.key.isEmpty && !$0.value.isEmpty }
                .map { ($0.key, $0.value) }
        )
        
        // Masukkan lokasi (jika ada)
        if let loc = selectedLocation {
            attributesDict["xPosition"] = String(format: "%.4f", loc.x)
            attributesDict["yPosition"] = String(format: "%.4f", loc.y)
        }
        
        // Buat item baru
        let newItem = sampleEquipment(
            assetID: idBarang,
            assetName: namaItem,
            assetLocation: lokasiBarang,
            assetSpecification: attributesDict
        )
        
        // Simpan ke ViewModel
        viewModel.add(newItem)
        
        // Tampilkan alert sukses
        showSuccessAlert = true
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        // FOTO
                        VStack {
                            if let image = selectedImage {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Button {
                                        selectedImage = nil
                                        selectedPhoto = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                    }
                                    .padding(8)
                                }
                                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                    Text("Ganti Foto")
                                        .font(.system(size: 14))
                                        .foregroundColor(.blue)
                                }
                            } else {
                                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .foregroundColor(.gray)
                                        .frame(height: 200)
                                        .overlay(
                                            VStack {
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.gray)
                                                Text("Pilih Foto")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                }
                            }
                        }
                        .onChange(of: selectedPhoto) { _, newPhoto in
                            Task {
                                if let newPhoto = newPhoto,
                                   let data = try? await newPhoto.loadTransferable(type: Data.self) {
                                    selectedImage = UIImage(data: data)
                                }
                            }
                        }
                        
                        // FIELD NAMA, ID, KATEGORI
                        RequiredFormField(
                            title: "Nama Item",
                            text: $namaItem,
                            placeholder: "Value",
                            isEmpty: namaItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                            showValidationError: showValidationError
                        )
                        
                        RequiredFormField(
                            title: "ID Barang",
                            text: $idBarang,
                            placeholder: "Value",
                            isEmpty: idBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                            showValidationError: showValidationError
                        )
                        
                        RequiredFormField(
                            title: "Lokasi Barang",
                            text: $lokasiBarang,
                            placeholder: "Value",
                            isEmpty: lokasiBarang.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                            showValidationError: showValidationError
                        )
                        
                        // SPECIFICATION
                        SpecificationSection(customAttributes: $customAttributes)
                        
                        // PREVIEW LOKASI
                        if let location = selectedLocation {
                            VStack {
                                Text("Lokasi Terpilih")
                                    .font(.headline)
                                GeometryReader { geo in
                                    if let uiImage = UIImage(named: "map") {
                                        let imageSize = uiImage.size
                                        ZStack {
                                            Image("map")
                                                .resizable()
                                                .scaledToFit()
                                            
                                            let point = location.positionIn(imageSize: imageSize, geoSize: geo.size)
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 20, height: 20)
                                                .position(point)
                                        }
                                    }
                                }
                                .frame(height: 200)
                                .cornerRadius(8)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(16)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 100)
                    
                    //Edit lokasi
                    if selectedLocation != nil {
                        NavigationLink(destination: LocationPickerView(selectedLocation: $selectedLocation)) {
                            Text("Edit Lokasi") .font(.system(size: 16, weight: .medium)) .foregroundColor(.white) .frame(maxWidth: .infinity) .frame(height: 50) .background(Color.gray) .cornerRadius(8) .padding(.horizontal, 20) } .padding(.bottom, 10) }
                    
                    //Tambah Lokasi & Simpan
                    if selectedLocation == nil {
                        NavigationLink(destination: LocationPickerView(selectedLocation: $selectedLocation)) {
                            Text("Tambahkan Lokasi")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.foregroundClr)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? Color.backgroundClr : Color.gray)
                                .cornerRadius(8)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 34)
                    } else {
                        Button(action: handleSave) {
                            Text("Simpan")
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
                        .alert("Item berhasil ditambahkan", isPresented: $showSuccessAlert) {
                            Button("OK") {
                                dismiss()
                            }
                        }
                    }
                    
                    if showValidationError && !isFormValid {
                        ErrorMessage()
                    }
                }
            }
            .navigationTitle("Tambahkan Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showLocationPicker) {
                LocationPickerView(selectedLocation: $selectedLocation)
            }
        }
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

#Preview {
    AddItemView()
        .environmentObject(EquipmentDataViewModel())
}
