//
//  FriendsViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/17/24.
//

import UIKit
import FirebaseDatabase
import Firebase

class FriendsViewController: UIViewController {
    var ref: DatabaseReference!
    var friends: [Friend] = []

    var userDeleteId:String = ""
    var userRecevierId:String = ""
    
    @IBAction func addTapped(_ sender: Any) {
        if !((emailTextFleld.text?.isEmpty)!){
            ref.child("players").queryOrdered(byChild: "email").queryEqual(toValue: emailTextFleld.text!).observe(.value, with: { snapshot in
                // Get user value
                if(snapshot.hasChildren()){
                    let allChildren = snapshot.children.allObjects as! [DataSnapshot]

                    for childSnapshot in allChildren{

                        guard let dic = childSnapshot.value as? [String : AnyObject] else {return}
                        var player = Player(aDict: dic)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowFriendViewController") as! ShowFriendViewController
                        vc.player = player
                        vc.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .pageSheet
                        self.present(vc, animated: true)
                        
                    }
                }else{
                    self.showAlert(message: "We don't have any palyer with this email!")
                }
          
                
//                guard let dic = snapshot.value as? [String : AnyObject] else {return}
//                print("Data == > \(dic)")
//               var player = Player(aDict: dic)
    //            let username = value?["username"] as? String ?? ""
                
    
               

          

              // ...
            }) { error in
              print(error.localizedDescription)
            }
            
        }
    }
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var emailTextFleld: UITextField!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var lavelLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!{
        didSet{
            avatarImage.layer.cornerRadius = 50
            avatarImage.clipsToBounds = true
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
    @IBOutlet weak var shapeBg: UIView!{
        didSet{
            shapeBg.layer.cornerRadius = 17.5;
            shapeBg.clipsToBounds = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        
        self.avatarImage.image = UIImage(named: GamesViewController.player!.avatar)
        self.coinsLabel.text = "\(GamesViewController.player!.coins)"
        self.lavelLabel.text = "LEVEL : \(GamesViewController.player!.level)"
    
        
        //load table data
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        guard let userID = Auth.auth().currentUser?.uid else {return}

        ref.child("friends").child(userID).observe(.value, with: { snapshot in
            // Get user value
            self.friends.removeAll()
            if(snapshot.hasChildren()){
                let allChildren = snapshot.children.allObjects as! [DataSnapshot]
                for childSnapshot in allChildren{
                    guard let dic = childSnapshot.value as? [String : AnyObject] else {return}
                    print("Data==>  childSnapshot \(childSnapshot)")
                    print("Data==>  dic \(dic)")
                   
                    var friend = Friend(aDict: dic)
                    print("Data==>  friend \(friend.player?.name)")

                    self.friends.append(friend)
                }
                self.tableView.reloadData()
            }
      
            
//                guard let dic = snapshot.value as? [String : AnyObject] else {return}
//                print("Data == > \(dic)")
//               var player = Player(aDict: dic)
//            let username = value?["username"] as? String ?? ""
            

           

      

          // ...
        }) { error in
          print(error.localizedDescription)
        }
        
        
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

extension FriendsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for:  indexPath) as! FriendTableViewCell
        cell.avatarImage.image = UIImage(named: friends[indexPath.row].player!.avatar)
        cell.name.text = friends[indexPath.row].player?.name
        cell.email.text = friends[indexPath.row].player?.email
        cell.index = indexPath.row
        cell.delegate = self
        
        if friends[indexPath.row].status == "new"{
            cell.optionStack.isHidden = false
        }else{
            cell.optionStack.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let userID = Auth.auth().currentUser?.uid else {return}
            userDeleteId = userID
            userRecevierId = friends[indexPath.row].player!.uid
            Database.database().reference().child("friends").child(userID).child(friends[indexPath.row].player!.uid).removeValue { error, ref in
                if error == nil {
                    Database.database().reference().child("friends").child(self.userRecevierId).child(self.userDeleteId).removeValue()
                }
            }
         
        }
    }
    
    
    
}
extension FriendsViewController : FriendTableViewCellDelegate{
    func rejectTapped(index: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("friends").child(userID).child(friends[index].player!.uid).removeValue()
    }
    
    func acceptTapped(index: Int) {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("friends").child(userID).child(friends[index].player!.uid).child("status").setValue("accepted") { error, ref in
            if error == nil {
                var friend = Friend(receiverId: userID, status: "accepted", player: GamesViewController.player!)
                
                Database.database().reference().child("friends").child(self.friends[index].player!.uid).child(userID).setValue(friend.dict)
            }
        }
        
        
    }
    
    
}
