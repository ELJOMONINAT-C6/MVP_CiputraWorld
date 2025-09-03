//
//  Equipment.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation

struct Equipment: Codable {
    let assetID: String
    let namaAlat: String
    let lokasiPemasangan: String
    let tanggalInstalasi: String
    let masaGaransi: String
    var imagePath: String?
    var spesifikasi: [String: String] // key-value bebas
}

class sampleEquipment: ObservableObject, Codable {
    var assetID: String
    var assetName: String
    var assetLocation: String
    var assetSpecification: [String: String]
    var imagePath: String?
    
    // Inisialisasi properti
    init(assetID: String, assetName: String, assetLocation: String, assetSpecification: [String: String] = [:], imagePath: String? = nil) {
        self.assetID = assetID
        self.assetName = assetName
        self.assetLocation = assetLocation
        self.assetSpecification = assetSpecification
        self.imagePath = imagePath
    }
}
