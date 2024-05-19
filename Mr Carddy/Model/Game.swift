//
//  Game.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/18/24.
//

import Foundation

class Game : Encodable{
    var id: String = ""
    var winerId: String = ""
    var coins: Int = 0
    var curentPlayer: String = ""
    var players:[String:Player] = [:]
    var lastCard:LastCard?
    
    init (aDict: [String: AnyObject]) {
        id = aDict["id"] as? String ?? ""
        winerId = aDict["winerId"] as? String ?? ""
        coins = aDict["coins"] as? Int ?? 0
        curentPlayer = aDict["curentPlayer"] as? String ?? ""
        var array = aDict["players"] as? [String : AnyObject] ??  [:]
        lastCard = LastCard(aDict: aDict["lastCard"] as? [String : AnyObject] ?? [:])
        for player in array {
            print("player == > \(player)")
            players[player.key] = Player(aDict: player.value as! [String : AnyObject]) 
        }
        
        
       }
    init(id: String, coins: Int,curentPlayer:String, players:[String:Player],lastCard:LastCard) {
        self.id = id
        self.coins = coins
        self.curentPlayer = curentPlayer
        self.players = players
        self.lastCard = lastCard
    }
    init(){}
}
