//
//  HighScore.swift
//  memory_game
//
//  Created by Liel Titelbaum on 14/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
class HighScore : Codable{
    
    var playerName:String = ""
    var score: Int = 0
    var gameLocation:Location = Location()
    var gameDate:String = ""
    
    init() {
        
    }
    
    init (score:Int, playerName:String, gameLocation:Location){
        self.score = score
        self.playerName = playerName
        self.gameLocation = gameLocation
        let currentDate = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .short
        formatterDate.locale = .current
        self.gameDate = formatterDate.string(from: currentDate)
    }
}
