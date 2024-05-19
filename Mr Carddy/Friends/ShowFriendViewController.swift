//
//  ShowFriendViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/17/24.
//

import UIKit
import Firebase
import FirebaseDatabase

class ShowFriendViewController: UIViewController {
    var ref: DatabaseReference!
    
    var player:Player?
    
    @IBOutlet weak var shapeLevel: UIView!{
        didSet{
            shapeLevel.layer.borderColor = UIColor.white.cgColor
            shapeLevel.layer.borderWidth = 1
            shapeLevel.layer.cornerRadius = 17.5;
            shapeLevel.clipsToBounds = true
        }
    }
    @IBOutlet weak var avatarImage: UIImageView!{
        didSet{
            avatarImage.layer.cornerRadius = 50
            avatarImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var closeImage: UIImageView!
    @IBAction func addTapped(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else {return}

        var friend = Friend(receiverId: player!.uid, status: "new", player: GamesViewController.player!)
        ref.child("friends").child(player!.uid).child(friend.player!.uid).setValue(friend.dict) { error, ref in
            if error == nil{
                let alert = UIAlertController(title: "Alert", message: "Friend request successfully", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.dismiss(animated: true)
            }
        }
        
    }
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        let tapCloseImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeImageTapped(tapGestureRecognizer:)))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tapCloseImageGestureRecognizer)
        
        guard let player = player else{return}
        avatarImage.image = UIImage(named: player.avatar)
        username.text = player.name
        email.text = player.email
        levelLabel.text = "LEVEL : \(player.level)"
        
    }
    

    
    @objc func closeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
        // Your action
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
