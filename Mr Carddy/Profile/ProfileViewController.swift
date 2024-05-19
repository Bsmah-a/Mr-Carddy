//
//  ProfileViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/15/24.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginOrRegisterViewController") as! LoginOrRegisterViewController
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @IBOutlet weak var shapeLevel: UIView!{
        didSet{
            shapeLevel.layer.borderColor = UIColor.white.cgColor
            shapeLevel.layer.borderWidth = 1
            shapeLevel.layer.cornerRadius = 17.5;
            shapeLevel.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeImage: UIImageView!
    var ref: DatabaseReference!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    var selectedAvaterImage:String = ""
    var player:Player?
    
    @IBAction func updateTapped(_ sender: Any) {
        if(selectedAvaterImage.isEmpty){
            // create the alert
                   let alert = UIAlertController(title: "Alert", message: "Select your avater name", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
            
        }else if(username.text!.isEmpty){
            let alert = UIAlertController(title: "Alert", message: "Enter your username", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
//            guard let id = Auth.auth().currentUser?.uid else {return}
//            var player = Player(uid: id ,name: username.text!,avatar: selectedAvaterImage,level: 1,coins: 1500)
            player?.avatar = selectedAvaterImage
            player?.name = username.text!
            ref.child("players").child(player!.uid).setValue(player.dict) { error, ref in
                if error == nil{
                    let alert = UIAlertController(title: "Alert", message: "Profile updated successfully", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBOutlet weak var avaterImage: UIImageView!{
        didSet{
            avaterImage.layer.cornerRadius = 50
            avaterImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var avaterView: UIView!
    @IBOutlet weak var editImage: UIImageView!
    let avatarNames = ["Avatar1", "Avatar2", "Avatar3", "Avatar4", "Avatar5", "Avatar6", "Avatar7", "Avatar8", "Avatar9", "Avatar10", "Avatar11", "Avatar12", "Avatar13", "Avatar14", "Avatar15", "Avatar16", "Avatar17", "Avatar18", "Avatar19"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference()

        
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nibBundle), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImageTapped(tapGestureRecognizer:)))
        editImage.isUserInteractionEnabled = true
        editImage.addGestureRecognizer(tapGestureRecognizer)
        
        let tapCloseImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeImageTapped(tapGestureRecognizer:)))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tapCloseImageGestureRecognizer)
        
        
        // Do any additional setup after loading the view.
        
        //load data
        
        //setData
        guard let player = player else{return}
        avaterImage.image = UIImage(named: player.avatar)
        selectedAvaterImage = player.avatar
        username.text = player.name
        email.text = player.email
        levelLabel.text = "LEVEL : \(player.level)"
        
      
    }
    
    @objc func editImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        collectionView.isHidden = false
        avaterView.isHidden = true
        // Your action
 

    }
    
    @objc func closeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        GamesViewController.player = player
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
extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.img.image = UIImage(named: avatarNames[indexPath.row])!
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.avaterImage.image = UIImage(named: avatarNames[indexPath.row])!
        collectionView.isHidden = true
        avaterView.isHidden = false
        selectedAvaterImage = avatarNames[indexPath.row];
    }
    
}
