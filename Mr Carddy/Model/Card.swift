//
//  Card.swift
//  Mr.Carddy
//
//  Created by Bsmah Ali on 23/10/1445 AH.
//

import Foundation

// type of Card
enum PhotoType: String {
   case cloock, coffee, besht, censer, Camel, Mosque, TV, Faisaliah, Palm,
        perfume, Farm, Kabsa, Woman, People, Mamlaka, Dalla , Shomag, Sword,
        Samosa , Date, Food, Makkah, Logo, hummus, Mountain, Flag, Water }

enum SpecialCard: String  {
    case Twice, Skip
}

struct Card: Identifiable,Hashable {
    let id: UUID = UUID()
    var c_name: String
    var selected = false
    var photo1: PhotoType?  // becomes nil if it is has Special card (Skip or Twice)
    var photo2: PhotoType? // becomes nil if it is has Special card (Skip or Twice)
    var especially: SpecialCard? // mybe nil if has photos
    
    init(c_name: String, photo1: PhotoType? = nil, photo2: PhotoType? = nil, especially: SpecialCard? = nil) {
        self.c_name = c_name
        self.photo1 = photo1
        self.photo2 = photo2
        self.especially = especially
    }
}





class LastCard : Encodable{
   
    var c_name: String = ""
    var photo1 : String = ""
    var photo2 : String = ""
    var isSpecialCard : Bool = false


    init (){}
    
    init (aDict: [String: AnyObject]) {
        c_name = aDict["c_name"] as? String ?? ""
        photo1 = aDict["photo1"] as? String ?? ""
        photo2 = aDict["photo2"] as? String ?? ""
        isSpecialCard = aDict["isSpecialCard"] as? Bool ?? false
       
        
       }
    init(c_name: String, photo1: String,photo2:String, isSpecialCard:Bool) {
        self.c_name = c_name
        self.photo1 = photo1
        self.photo2 = photo2
        self.isSpecialCard = isSpecialCard
    }
}
