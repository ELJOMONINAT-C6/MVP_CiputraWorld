//
//  Equipment.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation
import SwiftUI

class Equipment: Identifiable, Codable, ObservableObject {
    @Published var id: UUID
    @Published var assetID: String
    @Published var assetName: String
    @Published var assetLocation: String
    @Published var assetSpecification: [String: String]
    @Published var imagePath: String?
    @Published var createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case assetID = "asset_id"
        case assetName = "asset_name"
        case assetLocation = "asset_location"
        case assetSpecification = "asset_spec"
        case imagePath = "image_path"
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), assetID: String, assetName: String, assetLocation: String, assetSpecification: [String: String], imagePath: String? = nil, createdAt: Date? = nil) {
        self.id = id
        self.assetID = assetID
        self.assetName = assetName
        self.assetLocation = assetLocation
        self.assetSpecification = assetSpecification
        self.imagePath = imagePath
        self.createdAt = createdAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        assetID = try container.decode(String.self, forKey: .assetID)
        assetName = try container.decode(String.self, forKey: .assetName)
        assetLocation = try container.decode(String.self, forKey: .assetLocation)
        assetSpecification = try container.decode([String: String].self, forKey: .assetSpecification)
        imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(assetID, forKey: .assetID)
        try container.encode(assetName, forKey: .assetName)
        try container.encode(assetLocation, forKey: .assetLocation)
        try container.encode(assetSpecification, forKey: .assetSpecification)
        try container.encodeIfPresent(imagePath, forKey: .imagePath)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
    }

}

struct NewEquipment: Encodable {
    let asset_id: String
    let asset_name: String
    let asset_location: String
    let asset_spec: [String: String]
    let image_path: String?
}
