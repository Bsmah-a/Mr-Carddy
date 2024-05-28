//
//  CreateGameViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/18/24.
//

import UIKit
import FirebaseDatabase
import Firebase

class CreateGameViewController: UIViewController {
    var coinsCount:Int = 0
    
    let playViewController = PlayViewController()

    @IBAction func generateTapped(_ sender: Any) {
        codeLabel.text = "\(Int.randomNumberWith(digits: 6))"
    }
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var plus: UIImageView!
    @IBOutlet weak var min: UIImageView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var codeView: UIView!{
        didSet{
            codeView.layer.cornerRadius = 8
            codeView.clipsToBounds = true
        }
    }
    @IBOutlet weak var coinsView: UIView!{
        didSet{
            coinsView.layer.cornerRadius = 8
            coinsView.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        coinsLabel.text = "\(coinsCount) coins"
        let minTapGestureRecognizer = UITapGestureRecognizer(target: self, action:
        #selector(minTapTapped(tapGestureRecognizer:)))
        playViewController.playAudio(name: "Click")
        min.isUserInteractionEnabled = true
        min.addGestureRecognizer(minTapGestureRecognizer)
        
        
        let plusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusTapTapped(tapGestureRecognizer:)))
        playViewController.playAudio(name: "Click")
        plus.isUserInteractionEnabled = true
        plus.addGestureRecognizer(plusTapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    
    @objc func minTapTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        // Your action
        
        if coinsCount > 0 {
            coinsCount -= 10
            coinsLabel.text = "\(coinsCount) coins"
        }
       
    }
    
    @objc func plusTapTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        // Your action

            coinsCount += 10
            coinsLabel.text = "\(coinsCount) coins"
//        }
    }
    @IBAction func createTapped(_ sender: Any) {
        playViewController.playAudio(name: "Click")
        if(codeLabel.text! != "code"){
            var players:[String:Player] =  [:]
            // this is new way to add player by his id
            players[GamesViewController.player!.uid] = GamesViewController.player!
            
            var game  = Game(id: codeLabel.text!, coins: coinsCount, curentPlayer: GamesViewController.player!.uid,  players: players, lastCard: LastCard())
            
            if(game.coins > GamesViewController.player!.coins){
                self.showAlert(message: "Select coins under your coins")
            }else{
                Database.database().reference().child("games").child(game.id).setValue(game.dict) { error, ref in
                    if(error == nil){
                        Database.database().reference().child("players").child(GamesViewController.player!.uid).child("coins").setValue(GamesViewController.player!.coins - self.coinsCount)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
                        vc.game = game
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .flipHorizontal
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }else{
            self.showAlert(message: "Tap Generate Code")
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
