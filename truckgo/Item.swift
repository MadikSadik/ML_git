//
//  Item.swift
//  TruckGO
//
//  Created by Madiyar Bekmurat on 03.05.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
