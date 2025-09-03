//
//  CustomAttribute.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 02/09/25.
//

import Foundation

// Model untuk custom attribute
struct CustomAttribute: Identifiable {
    let id = UUID()
    var name: String = ""
    var value: String = ""
    
    var isCompleted: Bool = false
}
