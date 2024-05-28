//
//  GamesViewController.swift
//  Mr Carddy
//
//  Created by Bsmah Ali on 5/14/24.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AVFoundation


class GamesViewController: UIViewController {
   static var player:Player?
    let playViewController = PlayViewController()
    
    @IBAction func joinGameTapped(_ sender: Any) {
        playViewController.playAudio(name: "Click")
        
        showInputDialog(title: "Join Game",
                        subtitle: "Please enter the code game number below.",
                        actionTitle: "Join",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Code number",
                        inputKeyboardType: .numberPad, actionHandler:
                                { (input:String?) in
                                    print("The new number is \(input ?? "")")
            
            
                                // 1- search for game
            guard let gameCode = input else {return}
            Database.database().reference().child("games").child(gameCode).observeSingleEvent(of: .value) { dataSanpShot in
                if(dataSanpShot.exists()){
                    guard let dic = dataSanpShot.value as? [String : AnyObject] else {return}
                    var game = Game(aDict: dic)
                    print("Game Data==> \(dic)")
                    
                    if GamesViewController.player!.coins >= game.coins {
                        if game.players.count < 4 {
                            game.players.updateValue(GamesViewController.player!, forKey: GamesViewController.player!.uid)
                            
                            Database.database().reference().child("games").child(gameCode).setValue(game.dict) { error, ref in
                                if error == nil{
                                    //                                move to game seen
//                                    self.showAlert(message: "Added Successsfully move to game seen")
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
                                    vc.game = game
                                    vc.modalPresentationStyle = .fullScreen
                                    vc.modalTransitionStyle = .flipHorizontal
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                        }else{
                            self.showAlert(message: "Game is full" )
                        }
                    }else{
                        self.showAlert(message: "You Don't have \( game.coins) join to other game" )
                    }
                }else{
                    self.showAlert(message: "We Don't have game with this code" )
                }
                
            }
                               
            
            
                                })
        
    }
    
    @IBAction func createGameTapped(_ sender: Any) {
     // playViewController.playAduio(name: "Click")
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateGameViewController")
               
               if let presentationController = viewController!.presentationController as? UISheetPresentationController {
                   presentationController.detents = [.medium()] /// change to [.medium(), .large()] for a half *and* full screen sheet
               }
               
               self.present(viewController!, animated: true)
    }
    
    
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
    
    
    var ref: DatabaseReference!
    @IBOutlet weak var optionJoinGame: UIView!{
        didSet{
            optionJoinGame.layer.borderColor = UIColor(hexString: "A5D9FF").cgColor
            optionJoinGame.layer.borderWidth = 1
            optionJoinGame.layer.cornerRadius = 17.5;
            optionJoinGame.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var optionCreateGame: UIView!{
        didSet{
            optionCreateGame.layer.borderColor = UIColor(hexString: "A5D9FF").cgColor
            optionCreateGame.layer.borderWidth = 1
            optionCreateGame.layer.cornerRadius = 17.5;
            optionCreateGame.clipsToBounds = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref = Database.database().reference()
        ref.child("players").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            guard let dic = snapshot.value as? [String : AnyObject] else {return}
            GamesViewController.player = Player(aDict: dic)
//            let username = value?["username"] as? String ?? ""
            
            self.avatarImage.image = UIImage(named: GamesViewController.player!.avatar)
            self.coinsLabel.text = "\(GamesViewController.player!.coins)"
            self.lavelLabel.text = "LEVEL : \(GamesViewController.player!.level)"
           

      

          // ...
        }) { error in
          print("😡😡😡😡😡😡",error.localizedDescription)
        }
        
        

        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped(tapGestureRecognizer:)))
//        avatarImage.isUserInteractionEnabled = true
//        avatarImage.addGestureRecognizer(tapGestureRecognizer)
//
        // Do any additional setup after loading the view.
    }
    
    @objc func avatarImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.player = GamesViewController.player
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        // Your action
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.layerGradient(startPoint: .centerRight, endPoint: .centerLeft, colorArray: [UIColor(hexString: "0A171F").cgColor, UIColor(hexString: "1E435C").cgColor], type: .axial)

    }

    

}


public enum CAGradientPoint {
    case topLeft
    case centerLeft
    case bottomLeft
    case topCenter
    case center
    case bottomCenter
    case topRight
    case centerRight
    case bottomRight
    var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .centerLeft:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

extension CAGradientLayer {

    convenience init(start: CAGradientPoint, end: CAGradientPoint, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.frame.origin = CGPoint.zero
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}

extension UIView {

    func layerGradient(startPoint:CAGradientPoint, endPoint:CAGradientPoint ,colorArray:[CGColor], type:CAGradientLayerType ) {
        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: colorArray, type: type)
        gradient.frame.size = self.frame.size
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
//Int.randomNumberWith(digits: 6) // 453532

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.startIndex < 0 ? abs(range.startIndex) : 0
        let min = UInt32(range.startIndex + delta)
        let max = UInt32(range.endIndex   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
    
    static func randomNumberWith(digits: Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
}
extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

