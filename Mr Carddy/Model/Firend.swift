//
//  Firend.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/17/24.
//

import Foundation
class Friend: Encodable {
    var player: Player?
    var receiverId: String?
    var status: String?
  
    
    init (aDict: [String: AnyObject]) {
        receiverId = aDict["receiverId"] as? String ?? ""
        status = aDict["status"] as? String ?? ""
        player = Player(aDict: aDict["player"] as! [String : AnyObject])
       }
    init(receiverId: String, status: String,player:Player) {
        self.receiverId = receiverId
        self.player = player
        self.status = status
    }
    init(){}
    
    
}
