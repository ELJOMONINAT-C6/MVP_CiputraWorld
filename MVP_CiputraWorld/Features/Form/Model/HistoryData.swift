//
//  HistoryItem.swift
//  MVP_CiputraWorld
//
//  Created by Nathan Gunawan on 27/08/25.
//

import SwiftData
import Foundation

@Model
class HistoryItem {
    var machine: String
    var date: Date
    var details: String
    var notes: String?
    var photoData: Data?   // store image as Data
    
    init(machine: String, date: Date, details: String, notes: String? = nil, photoData: Data? = nil) {
        self.machine = machine
        self.date = date
        self.details = details
        self.notes = notes
        self.photoData = photoData
    }
}
