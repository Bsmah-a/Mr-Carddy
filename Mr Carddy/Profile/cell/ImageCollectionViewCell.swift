//
//  ImageCollectionViewCell.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/15/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!{
        didSet{
            img.layer.cornerRadius = 50
            img.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
