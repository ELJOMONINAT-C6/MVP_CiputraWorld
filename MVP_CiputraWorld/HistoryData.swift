//
//  HistoryItem.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

import SwiftData
import UIKit

@Model
class HistoryItem {
    var machine: String
    var date: Date
    var details: String
    var notes: String?
    var photoData: Data?
    
    init(machine: String, date: Date, details: String, notes: String? = nil, photo: UIImage? = nil) {
        self.machine = machine
        self.date = date
        self.details = details
        self.notes = notes
        if let photo, let data = photo.jpegData(compressionQuality: 0.8) {
            self.photoData = data
        }
    }
    
    // Helper: Convert photo back to UIImage
    var photo: UIImage? {
        if let data = photoData {
            return UIImage(data: data)
        }
        return nil
    }
}
