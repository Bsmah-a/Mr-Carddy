//
//  LoginOrRegisterViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/16/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class LoginOrRegisterViewController: UIViewController {
    
    var ref: DatabaseReference!

    
    var selectedAvaterImage:String = ""
    @IBOutlet weak var contanerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    //image
    
    @IBOutlet weak var avaterImage: UIImageView!{
        didSet{
            avaterImage.layer.cornerRadius = 50
            avaterImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var avaterView: UIView!
    @IBOutlet weak var editImage: UIImageView!
    let avatarNames = ["Avatar1", "Avatar2", "Avatar3", "Avatar4", "Avatar5", "Avatar6", "Avatar7", "Avatar8", "Avatar9", "Avatar10", "Avatar11", "Avatar12", "Avatar13", "Avatar14", "Avatar15", "Avatar16", "Avatar17", "Avatar18", "Avatar19"]
    //end

    @IBAction func btnTapped(_ sender: Any) {
        if btn.titleLabel!.text == "Login"{
            if ((email.text?.isEmpty)!){
             showAlert(message: "Enter your email")
            }else if ((password.text?.isEmpty)!){
                showAlert(message: "Enter your password")
            }else{
                //todo make login
                Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
                    if error == nil{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "tabsViewController")
                        vc?.modalPresentationStyle = .fullScreen
                        vc?.modalTransitionStyle = .flipHorizontal
                        self?.present(vc!, animated: true, completion: nil)
                    }else{
                        self?.showAlert(message: error?.localizedDescription ?? "")
                    }
                  // ...
                }
            }
        }else{
            if (selectedAvaterImage.isEmpty){
             showAlert(message: "Select your avater image")
            } else if ((username.text?.isEmpty)!){
                showAlert(message: "Enter your username")
               }else if ((email.text?.isEmpty)!){
             showAlert(message: "Enter your email")
            }else if ((password.text?.isEmpty)!){
                showAlert(message: "Enter your password")
            }else{
                //todo make register
                Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                    if error == nil{
                        // success
                        // todo make player and store his data to firebase database
                        guard let uid = authResult?.user.uid else{return}
                        var player = Player(uid: uid, name: self.username.text!,email: self.email.text!, avatar: self.selectedAvaterImage, level: 1, coins: 500, numberOfCardInGame: 15)
                        
                        self.ref.child("players").child(player.uid).setValue(player.dict) { error, ref in
                            if(error == nil){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabsViewController")
                                vc?.modalPresentationStyle = .fullScreen
                                vc?.modalTransitionStyle = .flipHorizontal
                                self.present(vc!, animated: true, completion: nil)
                            }else{
                                self.showAlert(message: error?.localizedDescription ?? "")
                            }
                        }

                    }else{
                        self.showAlert(message: error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBAction func degemntedOptionTapped(_ sender: Any) {
        if segmentedOption.selectedSegmentIndex == 0 {
            contanerView.isHidden = true
            username.isHidden = true
            btn.setTitle("Login", for: .normal)
        }else{
            contanerView.isHidden = false
            username.isHidden = false
            btn.setTitle("Register", for: .normal)
        }
    }
    @IBOutlet weak var segmentedOption: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImageTapped(tapGestureRecognizer:)))
        editImage.isUserInteractionEnabled = true
        editImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        // register cell
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")

        // Do any additional setup after loading the view.
        
//        print("Auth.auth().currentUser \(Auth.auth().currentUser!.uid)  \(Auth.auth().currentUser != nil)" )
//        if Auth.auth().currentUser != nil{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabsViewController")
//            vc?.modalPresentationStyle = .fullScreen
//            vc?.modalTransitionStyle = .flipHorizontal
//            self.present(vc!, animated: true, completion: nil)
//        }
        
    }
    
    @objc func editImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        
        avaterView.isHidden = true
        collectionView.isHidden = false
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

extension UIViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
   
}

extension LoginOrRegisterViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.img.image = UIImage(named: avatarNames[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        avaterImage.image = UIImage(named: avatarNames[indexPath.row])
        selectedAvaterImage = avatarNames[indexPath.row]
        collectionView.isHidden = true
        avaterView.isHidden = false
    }
    
}


