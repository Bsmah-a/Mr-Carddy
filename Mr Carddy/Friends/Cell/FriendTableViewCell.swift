//
//  FriendTableViewCell.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/18/24.
//

import UIKit
protocol FriendTableViewCellDelegate {
    func rejectTapped(index:Int)
    func acceptTapped(index:Int)
}
class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var reject: UIImageView!
    @IBOutlet weak var accept: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    var delegate:FriendTableViewCellDelegate?
    var index:Int?
    
    @IBOutlet weak var avatarImage: UIImageView!{
        didSet{
            avatarImage.layer.cornerRadius = 20
            avatarImage.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var optionStack: UIStackView!
    
    @IBAction func rejectTapped(_ sender: Any) {
        delegate?.rejectTapped(index: index ?? -1)

    }
    @IBAction func acceptTapped(_ sender: Any) {
        delegate?.acceptTapped(index: index ?? -1)

    }
    
    
    
}
