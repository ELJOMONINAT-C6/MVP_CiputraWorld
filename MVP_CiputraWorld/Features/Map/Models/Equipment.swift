//
//  Equipment.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import SwiftUI

//struct Equipment: Codable {
//    let assetID: String
//    let namaAlat: String
//    let lokasiPemasangan: String
//    let tanggalInstalasi: String
//    let masaGaransi: String
//    var imagePath: String?
//    var spesifikasi: [String: String] // key-value bebas
//}

class sampleEquipment: ObservableObject, Codable {
    @Published var assetID: String
    @Published var assetName: String
    @Published var assetLocation: String
    @Published var assetSpecification: [String: String]
    @Published var imagePath: String?
    
    init(assetID: String, assetName: String, assetLocation: String, assetSpecification: [String: String] = [:], imagePath: String? = nil) {
        self.assetID = assetID
        self.assetName = assetName
        self.assetLocation = assetLocation
        self.assetSpecification = assetSpecification
        self.imagePath = imagePath
    }
    
    enum CodingKeys: String, CodingKey {
          case assetID, assetName, assetLocation, assetSpecification, imagePath
      }
      
      required init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          assetID = try container.decode(String.self, forKey: .assetID)
          assetName = try container.decode(String.self, forKey: .assetName)
          assetLocation = try container.decode(String.self, forKey: .assetLocation)
          assetSpecification = try container.decode([String: String].self, forKey: .assetSpecification)
          imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
      }
      
      func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(assetID, forKey: .assetID)
          try container.encode(assetName, forKey: .assetName)
          try container.encode(assetLocation, forKey: .assetLocation)
          try container.encode(assetSpecification, forKey: .assetSpecification)
          try container.encode(imagePath, forKey: .imagePath)
      }
}
