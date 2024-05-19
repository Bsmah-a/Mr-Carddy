//
//  CardCollectionViewCell.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/18/24.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!{
        didSet{
            cardView.layer.cornerRadius = 8
            cardView.layer.masksToBounds = true
            cardView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var card: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
