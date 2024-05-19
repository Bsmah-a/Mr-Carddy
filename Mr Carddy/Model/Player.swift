//
//  Player.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/15/24.
//

import Foundation


class Player: Encodable {
    var uid: String = ""
    var name: String = ""
    var email: String = ""
    var avatar : String = ""
    var level: Int = 0
    var coins: Int = 0
    var numberOfCardInGame: Int = 15
    
    init (aDict: [String: AnyObject]) {
       uid = aDict["uid"] as? String ?? ""
        name = aDict["name"] as? String ?? ""
       avatar = aDict["avatar"] as? String ?? ""
        level = aDict["level"] as? Int ?? 0
       coins = aDict["coins"] as? Int ?? 0
        email = aDict["email"] as? String ?? ""
       }
    init(uid: String, name: String,email:String, avatar: String, level: Int, coins: Int) {
        self.uid = uid
        self.name = name
        self.avatar = avatar
        self.level = level
        self.coins = coins
        self.email = email
    }
    init(){}
    
    
}

extension Encodable {
    var dict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
