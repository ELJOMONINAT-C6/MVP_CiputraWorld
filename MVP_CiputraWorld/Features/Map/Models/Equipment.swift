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
