//
//  MyUserDefults.swift
//  memory_game
//
//  Created by Liel Titelbaum on 19/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation

class MyJson {
    func convertListToJson(highScores: [HighScore]) -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! jsonEncoder.encode(highScores)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        
        return json
    }
    
    
    // Decode
    func convertJsonToList(json: String) -> [HighScore]? {
        let jsonDecoder = JSONDecoder()
        if json != "" {
            let highScores: [HighScore]
            let convertedData: Data = json.data(using: .utf8)!
            highScores = try! jsonDecoder.decode([HighScore].self,from: convertedData)
            return highScores
        }
        else{
            return [HighScore]()
        }
    }
}


class MyUserDefaults {
    private var myJson :MyJson = MyJson()
    private let userDefaultsKey:String = "HighScoreKey_userDefaults"
    
    //Store and retrive to/from UserDefults with json
    
    func storeUserDefaults(highScores: [HighScore]){
        UserDefaults.standard.set(myJson.convertListToJson(highScores: highScores),forKey: userDefaultsKey)
    }
    
    func retriveUserDefualts() -> [HighScore]{
        if let highScores: [HighScore] = myJson.convertJsonToList(json: UserDefaults.standard.string(forKey: userDefaultsKey) ?? ""){
                   return highScores
        }
        return [HighScore]()
    }
    func clearUserDefaults(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}
