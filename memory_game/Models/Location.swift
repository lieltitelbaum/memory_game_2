//
//  Location.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation

class Location: Codable {
    var longitude : Double = 0
    var latitude : Double = 0

    init (){}
    
    init (latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var toString: String {
        return "latitude: \(self.latitude), longitude: \(self.longitude)"
    }
}
