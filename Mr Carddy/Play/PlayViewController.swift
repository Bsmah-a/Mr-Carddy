//
//  PlayViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/18/24.


import Firebase
import FirebaseDatabase
import AVFoundation
import UIKit

class PlayViewController: UIViewController {
    var sahbaCards:[Card] = []
    var game:Game?
    var player: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?

    

    var cards : [Card] = []
    var cardsAllCard : [Card] = [
        Card(c_name: "Card1", photo1: nil, photo2: nil, especially: .Skip),
        Card(c_name: "Card2", photo1: nil, photo2: nil, especially: .Twice),
        Card(c_name: "Card3", photo1:.cloock, photo2: .Mosque, especially: nil),
        Card(c_name: "Card4", photo1: .TV, photo2: .Faisaliah, especially: nil),
        Card(c_name: "Card5", photo1: .coffee, photo2: .Mosque, especially: nil),
        Card(c_name: "Card6" ,photo1:.Palm, photo2: .perfume, especially: nil),
        Card(c_name: "Card7", photo1: .TV, photo2:.Palm , especially: nil),
        Card(c_name: "Card8", photo1: .Farm, photo2: .Kabsa, especially: nil),
        Card(c_name: "Card9", photo1: .Woman, photo2: .Mamlaka, especially: nil),
        Card(c_name: "Card10", photo1: .Faisaliah, photo2: .besht, especially: nil),
        Card(c_name: "Card11", photo1:.Dalla , photo2:.Shomag, especially: nil ),
        Card(c_name: "Card12", photo1: .Shomag, photo2: .Faisaliah, especially: nil),
        Card(c_name: "Card13", photo1: .Sword, photo2: .Woman, especially: nil),
        Card(c_name: "Card14", photo1: .Samosa, photo2:.Date, especially: nil),
        Card(c_name: "Card15", photo1: .Food, photo2: .Makkah, especially: nil),
        Card(c_name: "Card16", photo1: .Logo, photo2: .censer, especially: nil),
        Card(c_name: "Card17", photo1:.hummus , photo2:.Food, especially: nil ),
        Card(c_name: "Card18", photo1:.besht, photo2:.Dalla, especially: nil),
        Card(c_name: "Card19", photo1: .Camel, photo2: .Mountain, especially: nil),
        Card(c_name: "Card20", photo1: .Shomag, photo2: .Sword, especially: nil),
        Card(c_name: "Card21" ,photo1: .Date, photo2: .coffee, especially: nil),
        Card(c_name: "Card22", photo1: .perfume, photo2: .censer, especially: nil),
        Card(c_name: "Card23", photo1: .censer, photo2:.Food, especially: nil ),
        Card(c_name: "Card24", photo1: .Palm, photo2: .Farm, especially: nil),
        Card(c_name: "Card25", photo1: .besht, photo2:.Woman, especially: nil ),
        Card(c_name: "Card26", photo1: .Kabsa, photo2: .Samosa, especially: nil),
        Card(c_name: "Card27", photo1: .Flag, photo2:.Logo, especially: nil ),
        Card(c_name: "Card28", photo1: .perfume, photo2: .Farm, especially: nil),
        Card(c_name: "Card29", photo1: .Mamlaka, photo2:.Water, especially: nil),
        Card(c_name: "Card30", photo1: .Woman, photo2: .perfume, especially: nil),
        Card(c_name: "Card31", photo1: .Water, photo2:.TV, especially: nil ),
        Card(c_name: "Card32", photo1: .Kabsa, photo2: .Logo, especially: nil),
        Card(c_name: "Card33", photo1: .Food, photo2: .Mosque, especially: nil),
        Card(c_name: "Card34", photo1: .Camel, photo2: .cloock, especially: nil),
        Card(c_name: "Card35", photo1: .coffee, photo2: .hummus, especially: nil),
        Card(c_name: "Card36" ,photo1: .cloock, photo2: .Makkah, especially: nil),
        Card(c_name: "Card37", photo1: .Faisaliah, photo2:.Mamlaka, especially: nil ),
        Card(c_name: "Card38", photo1: .besht, photo2:.Shomag, especially: nil ),
        Card(c_name: "Card39", photo1: .hummus, photo2: .Sword, especially: nil),
        Card(c_name: "Card40", photo1: .Logo, photo2: .Sword, especially: nil),
        Card(c_name: "Card41", photo1: .Dalla, photo2: .Flag, especially: nil),
        Card(c_name: "Card42", photo1: .Makkah, photo2: .People, especially: nil),
        Card(c_name: "Card43", photo1: .Mountain, photo2:.hummus, especially: nil ),
        Card(c_name: "Card44", photo1: .Water, photo2:.Flag, especially: nil),
        Card(c_name: "Card45", photo1: .Mountain, photo2: .coffee, especially: nil),
        Card(c_name: "Card46", photo1: .People, photo2:.perfume, especially: nil),
        Card(c_name: "Card47", photo1: .Mosque, photo2:.TV, especially: nil ),
        Card(c_name: "Card48", photo1: .Mamlaka, photo2: .Date, especially: nil),
        Card(c_name: "Card49", photo1: .Makkah, photo2: .Water, especially: nil),
        Card(c_name: "Card50", photo1: .cloock, photo2:.People, especially: nil ),
        Card(c_name: "Card51", photo1: .Flag, photo2: .Samosa, especially: nil),
        Card(c_name: "Card52", photo1: .Date, photo2: .Camel, especially: nil)
    ]

    
    
    var player1:Player?
    
    @IBOutlet weak var close: UIImageView!
    
    @IBOutlet weak var totalCoins: UILabel!
    var lastCard:LastCard?
    
   
    // make 15 on start ==> don
    // count down ==> don
    // spatel card 3 or 2 == don
    // close and win and lose ==> working
    // card nmber ==>
    // coins == > don
    // careate move to game  ==> Don

    func getRandomItems(from originalArray: [Card], count: Int) -> [Card] {
        var randomItems: [Card] = []
        
        for _ in 0..<count {
            guard let randomIndex = (0..<originalArray.count).randomElement() else {
                continue
            }
            randomItems.append(originalArray[randomIndex])
        }
        
        return randomItems
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.layer.cornerRadius = 8
            collectionView.clipsToBounds = true
        }
    }
    var isFisrtTime = false
    var ids:[String] = []
    var selectedCard:Card?
    var seconds = 40
    var myTimer: Timer?
    
    //Close Game ...........
    @objc func closeTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
     
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to leave this game?", preferredStyle: UIAlertController.Style.alert)
        //timer stop

        // add an action (button)
        alert.addAction(UIAlertAction(title: "STAY", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "LEAVE", style: .default, handler: { action in
            // make win for player and lose for other player
            
            Database.database().reference().child("games").child(self.game!.id).child("winerId").setValue(self.player1!.uid)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTapped(tapGestureRecognizer:)))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        
        Database.database().reference().child("games").child(game!.id).observe(.value) { dataSanpShot, error in
            
            guard let dic = dataSanpShot.value as? [String : AnyObject] else {return}
            self.game = Game(aDict: dic)
            
            
            
       
            
            self.totalCoins.text = "\(self.game!.coins)"

//            if !self.isFisrtTime {
//                self.isFisrtTime = true
                var tempDic:[String:Player] = [:]
                for player in self.game!.players {
                    if(player.key != GamesViewController.player!.uid){
                        tempDic[player.key] = player.value
                    }
                }
                if(self.game!.players.count == 2){
                    let firstKey = Array(tempDic.keys)[0] // or .first
                    self.player1 = tempDic[firstKey]
                    self.player1Name.text = self.player1?.name
                    self.numberOfCardPlayer1.text = "\(self.player1!.numberOfCardInGame)"
                    self.player1Level.text = "\(self.player1!.level)"
                    self.avatarPlayer1Image.image = UIImage(named: self.player1!.avatar)
                }else if(self.game!.players.count == 1){
                    self.player1MainView.isHidden = true
                }
                
               // self.ids =  Array(self.game!.players.keys)
//            }
            
            
//            //make numer of card realtiem
//
//            Database.database().reference().child("games").child(self.game!.id).child("players").child(self.player1!.uid).observe(.value) { snapshot in
//                guard let dic = snapshot.value as? [String : AnyObject] else {return}
////                self.player1 = Player(aDict: dic)
////                self.numberOfCardPlayer1.text = "\(self.player1!.numberOfCardInGame)"
//                print("numberOfCardInGame ==> \(dic)")
//            }
                
            if self.game!.curentPlayer == GamesViewController.player!.uid{
                self.countDownMainPlayer.isHidden = false
                self.player1CoundDown.isHidden = true
            }else{
                self.countDownMainPlayer.isHidden = true
                self.player1CoundDown.isHidden = false
            }
            
            //show winer message
            if self.game!.winerId == GamesViewController.player!.uid {
                
                let showAlert = UIAlertController(title: "You Did it", message: "Congratulations on your win \(self.game!.coins)" , preferredStyle: .alert)
              
                let imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 90, height: 90))
                self.playAudio(name: "Winner")
                imageView.image = UIImage(named: "winner") // Your image here...
                showAlert.view.addSubview(imageView)
                let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                showAlert.view.addConstraint(height)
                showAlert.view.addConstraint(width)
                showAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    // add coins to me
                    GamesViewController.player!.coins  += self.game!.coins
                    Database.database().reference().child("players").child(GamesViewController.player!.uid).child("coins").setValue(GamesViewController.player!.coins)
                    self.dismiss(animated: true)
                }))
                self.present(showAlert, animated: true, completion: nil)
            }else if(!self.game!.winerId.isEmpty){
                // show lose message
                
                let showAlert = UIAlertController(title: "Game Over", message: "The game is over and you have lost" , preferredStyle: .alert)
                self.playAudio(name: "gameOver")
                let imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 90, height: 90))
                imageView.image = UIImage(named: "loser") // Your image here...
                showAlert.view.addSubview(imageView)
                let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                showAlert.view.addConstraint(height)
                showAlert.view.addConstraint(width)
                showAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    // your actions here...
                   
                    self.dismiss(animated: true)
                    
                }))
                self.present(showAlert, animated: true, completion: nil)
            }
            
            //end
            
            
            
            
            
            //show count down
            if self.game!.curentPlayer == GamesViewController.player!.uid{
               
                self.seconds = 40
                self.playAudio(name: "Timer")
                self.myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                            self?.seconds -= 1
                            if self?.seconds == 0 {
                               // self?.showAlert(message: "Go!")
                                self?.addWhenTimeFinish()
                                self?.countDownMainPlayer.isHidden = true
                                self?.player1CoundDown.isHidden = false
                                self?.myTimer!.invalidate()
                               // self?.stopAudio() // Stop the audio playback
                            } else if let seconds = self?.seconds {
                                self?.countDownMainPlayer.text = "\(seconds)"
                            }
                        }

            }else {
                self.countDownMainPlayer.isHidden = true
                self.player1CoundDown.isHidden = false

                self.seconds = 40

                self.myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                            self?.seconds -= 1
                            if self?.seconds == 0 {
                                //self?.showAlert(message: "Go!")
                                self?.addWhenTimeFinish()
                                self?.countDownMainPlayer.isHidden = false
                                self?.player1CoundDown.isHidden = true
                                self?.myTimer!.invalidate()
                            } else if let seconds = self?.seconds {
                                self?.player1CoundDown.text = "\(seconds)"
                            }
                        }
            }
            
            //show last card
            if(!self.game!.lastCard!.c_name.isEmpty){
                self.lastCardImage.image = UIImage(named: self.game!.lastCard!.c_name)
            }
           
          
            

            
        }
        
       
        
        
        
        
    }
    @IBOutlet weak var optionView: UIView!{
        didSet{
            optionView.layer.cornerRadius = 28
            optionView.clipsToBounds = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        cardsAllCard.shuffle()
        cards.append(contentsOf: getRandomItems(from: cardsAllCard, count: 15))
        cards.append(Card(c_name: "Card1", photo1: nil, photo2: nil, especially: .Skip))
        cards.append( Card(c_name: "Card2", photo1: nil, photo2: nil, especially: .Twice))
        collectionView.reloadData()
        
        
        // make random cards for add
        sahbaCards.append(contentsOf: cardsAllCard[randomPick: 52])
        sahbaCards.append(contentsOf: cardsAllCard[randomPick: 52])
        sahbaCards.append(contentsOf: cardsAllCard[randomPick: 52])
        avaterMainPlayer.image = UIImage(named: GamesViewController.player!.avatar)
    }
 

    //player 1
    
    @IBOutlet weak var player1CoundDown: UILabel!
    @IBOutlet weak var numberOfCardPlayer1: UILabel!{
        didSet{
            numberOfCardPlayer1.layer.cornerRadius = numberOfCardPlayer1.frame.height / 2
            numberOfCardPlayer1.clipsToBounds = true
        }
    }
    @IBOutlet weak var avaterPlayer1View: UIView!{
        didSet{
            avaterPlayer1View.layer.cornerRadius = 30
            avaterPlayer1View.layer.masksToBounds = true
            avaterPlayer1View.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var player1MainView: UIView!
    @IBOutlet weak var avatarPlayer1Image: UIImageView!
    
    @IBOutlet weak var player1Name: UILabel!{
        didSet{
            player1Name.layer.cornerRadius = 8
            player1Name.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var player1Level: UILabel!
    //end
 
    
    
 
    
    
    // main player (me)
    
    @IBOutlet weak var viewAvatrMainPlayer: UIView!{
        didSet{
            viewAvatrMainPlayer.layer.cornerRadius = 30
            viewAvatrMainPlayer.layer.masksToBounds = true
            viewAvatrMainPlayer.clipsToBounds = true
        }
    }
    @IBOutlet weak var avaterMainPlayer: UIImageView!
    @IBOutlet weak var countDownMainPlayer: UILabel!
    //end
    
    @IBOutlet weak var lastCardImage: UIImageView!{
        didSet{
            lastCardImage.layer.cornerRadius = 8
            lastCardImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var coinsView: UIView!{
        didSet{
            coinsView.layer.cornerRadius = coinsView.frame.height /  2
            
            coinsView.clipsToBounds = true
        }
    }
    
    
    //options
    
    //add when time finish
    func addWhenTimeFinish(){
        if(game!.curentPlayer == GamesViewController.player!.uid){
            cards.append(sahbaCards[Int.random(in: 1...150)])
            
            // todo add new number to player
            
            Database.database().reference().child("games").child(self.game!.id).child("curentPlayer").setValue(self.player1!.uid) { erroe, ref in
                Database.database().reference().child("games").child(self.game!.id).child("players").child(GamesViewController.player!.uid).child("numberOfCardInGame").setValue(self.cards.count)
            }
            print("Cards Count == > \(cards.count)")
            collectionView.reloadData()}
        self.stopAudio()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        playAudio(name: "sahba")
        if(game!.curentPlayer == GamesViewController.player!.uid){
            cards.append(sahbaCards[Int.random(in: 1...150)])
            
            // todo add new number to player
            
            Database.database().reference().child("games").child(game!.id).child("players").child(GamesViewController.player!.uid).child("numberOfCardInGame").setValue(cards.count)
            collectionView.reloadData()
        }
    }
   

    //when press Done, check the card
    var specialCardCount = 0
    @IBAction func playTapped(_ sender: Any) {
        playAudio(name: "buttons")
        
        if self.game!.curentPlayer == GamesViewController.player!.uid{
            
            Database.database().reference().child("games").child(game!.id).child("lastCard").setValue(lastCard.dict) { error, ref in
                if error == nil{
                    if(self.specialCardCount != 0){
                        self.specialCardCount -= 1
                    }else{
                        if (self.lastCard!.isSpecialCard){
                            if(self.selectedCard?.especially?.rawValue == "Skip"){
                                self.specialCardCount = 1
                            }else if (self.selectedCard?.especially?.rawValue == "Twice"){
                                self.specialCardCount = 2
                            }
                            Database.database().reference().child("games").child(self.game!.id).child("players").child(GamesViewController.player!.uid).child("numberOfCardInGame").setValue(self.cards.count)
                        }else{
                            Database.database().reference().child("games").child(self.game!.id).child("curentPlayer").setValue(self.player1!.uid)
                            self.selectedCard = nil
                            Database.database().reference().child("games").child(self.game!.id).child("players").child(GamesViewController.player!.uid).child("numberOfCardInGame").setValue(self.cards.count)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        playAudio(name: "button")
        
        if(selectedCard != nil){
            cards.append(self.selectedCard!)
            selectedCard = nil
            if(!self.game!.lastCard!.c_name.isEmpty){
                self.lastCardImage.image = UIImage(named: self.game!.lastCard!.c_name)
            }
            collectionView.reloadData()
        }
        
        
    }
    
    func playAudio(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    /*func playAduio(name:String){
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
    }*/
    

}
extension PlayViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        print("  cell.card.image \(cards[indexPath.row].c_name)")
        cell.card.image = UIImage(named: cards[indexPath.row].c_name)
        
        return cell;
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(game!.curentPlayer != GamesViewController.player!.uid){
            return
        }
        
        
        
        selectedCard = cards[indexPath.row]
 
        if(specialCardCount > 0){
            
            if(selectedCard!.especially != nil) {
                lastCard = LastCard(c_name: selectedCard!.c_name, photo1: "", photo2: "", isSpecialCard:  true )
                 lastCardImage.image = UIImage(named: cards[indexPath.row].c_name)
                 cards.remove(at: indexPath.row)
                 collectionView.reloadData()
            }else {
              
                     lastCard = LastCard(c_name: selectedCard!.c_name, photo1: selectedCard!.photo1!.rawValue, photo2: selectedCard!.photo2!.rawValue, isSpecialCard: false)
            
               
                lastCardImage.image = UIImage(named: cards[indexPath.row].c_name)
                cards.remove(at: indexPath.row)
                collectionView.reloadData()
            }
        }else if(selectedCard!.especially != nil) {
            lastCard = LastCard(c_name: selectedCard!.c_name, photo1: "", photo2: "", isSpecialCard:  true )
             lastCardImage.image = UIImage(named: cards[indexPath.row].c_name)
             cards.remove(at: indexPath.row)
             collectionView.reloadData()
        }else if(game!.lastCard!.photo1 == selectedCard!.photo1!.rawValue || game!.lastCard!.photo1 == selectedCard!.photo2!.rawValue || game!.lastCard!.photo2 == selectedCard!.photo1!.rawValue || game!.lastCard!.photo2 == selectedCard!.photo2!.rawValue  ){
          
                 lastCard = LastCard(c_name: selectedCard!.c_name, photo1: selectedCard!.photo1!.rawValue, photo2: selectedCard!.photo2!.rawValue, isSpecialCard: false)
        
           
            lastCardImage.image = UIImage(named: cards[indexPath.row].c_name)
            cards.remove(at: indexPath.row)
            collectionView.reloadData()
        }else  if(self.game!.lastCard!.c_name.isEmpty){
            lastCard = LastCard(c_name: selectedCard!.c_name, photo1: selectedCard!.photo1!.rawValue, photo2: selectedCard!.photo2!.rawValue, isSpecialCard: false)
   
      
       lastCardImage.image = UIImage(named: cards[indexPath.row].c_name)
       cards.remove(at: indexPath.row)
           
       collectionView.reloadData()
        }else{
            self.showAlert(message: "Select card with at least one matched photo")
        }
       
        
        
        
    }
    
    
}
extension Array {
    /// Picks n random elements (partial Fisher-Yates shuffle approach)
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}
