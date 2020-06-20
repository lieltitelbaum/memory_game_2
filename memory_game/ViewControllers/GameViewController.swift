//
//  GameViewController.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/05/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import CoreLocation

class GameViewController: UIViewController {
    
    //vars
    @IBOutlet var game_BTN_cards: [UIButton]!//collection of all the card buttons
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_LBL_moves_headline: UILabel!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_score: UILabel!
    
    private var previousButton: UIButton!
    
    //lcations vars
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var isUpdatingLocation: Bool = false
    private var lastLocationError: Error?
    private var isPermission: Bool = false
    
    private var myUserDef = MyUserDefaults()
    private var highScores = [HighScore]()
    
    public var userName:String = ""
    private var isUserWon:Bool = false
    private var game = Game()
    private var counter: Int = 0//pressing cards counter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
        game.setPlayingStatus(status: true)
    }
    
    func setGameLabels() {
        game_LBL_moves.text = String(game.getMovesNum())
        game_LBL_timer.text = "00:00"
        game_LBL_moves_headline.text = "Moves"
        game_LBL_score.text = "Score: 0"
    }
    
    func initGame() {
        game.initGameProperties()
        setGameLabels()
        game.resetCards()
        game.shuffleCards()
        game.setTimer(on: true, timerLabel: game_LBL_timer)
        
        for card in game_BTN_cards {
            card.isEnabled = true
            game.closeCard(card: card)
        }
    }
    
    func isCardsMatch(previous: UIButton, current: UIButton) {
        //if cards match-> add score to user
        if(game.checkMatch(previous: previous, current: current)) {
            game.setScore(score: game.getScore() + 10)
            game_LBL_score.text = "Score: " + String(game.getScore())
        }
    }
    
    @IBAction func button_clicked(_ sender: UIButton){
        if(game.getPlayingStatus()) {
            counter += 1 //amount of button clicks
            game.openCard(card: sender)
            
            if(counter % 2 == 0){
                if(sender != previousButton){
                    game.setCurrentPlayerMoves(moves: game.getCurrentPlayerMoves() - 1)
                    game_LBL_moves.text = String(game.getCurrentPlayerMoves())
                    isCardsMatch(previous: previousButton, current: sender)
                }
                else{//if the user click on the same card- don't count the number of moves
                    counter = 1
                }
            }
            previousButton = sender
            
            isUserWon = game.checkIfWinner(timerLbl: game_LBL_timer)
            gameOver()
        }
    }
    
    func gameOver(){
        let isStillPlaying = game.getPlayingStatus()
        if(!isStillPlaying){
            game_LBL_moves.text = ""
            game_LBL_moves_headline.text = ""
            if(isUserWon){
                //if user won check if there are location permissions-> if so, get location
                //if not-> present an alert
                let scoreNewIndex = checkifHighScore(score: game.getScore())
                if scoreNewIndex {
                    isPermission = findLocation()
                    startLocationManager()
                    if(isPermission){
                        createAlertForUserName()
                    }
                }
                else {
                    //if user won and didn't make it to top 10
                    alertPlayAgain(titel: "Congratulation!", msg: "You won!")
                }
            }
            else {
                //if user lost
                alertPlayAgain(titel: "Sorry ", msg: "You lost, better luck next time!")
            }
            
        }
    }
    
    func alertPlayAgain(titel: String, msg: String) {
        let alert = UIAlertController(title: titel, message: msg ,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Play again", style: .default,handler: { (action) -> Void in
            self.initGame()
            self.game.setPlayingStatus(status: true)
        })
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func startLocationManager() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
    
    func findLocation() -> Bool//premisions
    {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        if authStatus == .denied || authStatus == .restricted {
            reportLocationServicesDenied()
            return false
        }
        return true
    }
    
    func  reportLocationServicesDenied() {
        let alert = UIAlertController(title: "Opps! location services are disabled.", message: "Pleas go to Settings > Privacy to enable location services for this app.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func createAlertForUserName() {
        //get name from user throgh alertController
        let alert = UIAlertController(title: "Congratulation! ",
                                      message: " You won and one of top ten players!",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Save my high score", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let name = alert.textFields![0].text
            print(alert.textFields![0].text!)
            self.saveNewHighScore(name: name!)
            self.performSegue(withIdentifier: "moveToTopTen", sender: self)
        })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter your name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkifHighScore(score: Int) -> Bool {
        //check if user score can be one of top 10 scores
        highScores = myUserDef.retriveUserDefualts()
        if highScores.count == 10{
            highScores.sort(by: {$0.score > $1.score})
            for highScore in highScores {
                //if new score is bigger
                if(highScore.score < score){
                    return true
                }
            }
        }
        else if highScores.count < 10{
            return true
        }
        return false
    }
    
    func saveNewHighScore(name: String) {
        //save new high score and update userDefaults
        let userLocation: Location = Location(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        if(userLocation.longitude != 0 && userLocation.latitude != 0) {
            let highScore = HighScore(score: game.getScore(), playerName: name, gameLocation: userLocation)
            var highScoreList = myUserDef.retriveUserDefualts()
            if (highScoreList.count == 10) {
                //remove the last player with the loweset score
                highScoreList.remove(at: highScoreList.count - 1)
            }
            highScoreList.append(highScore)//add new high score
            highScoreList.sort(by: {$0.score > $1.score})//sort by score amount
            myUserDef.storeUserDefaults(highScores: highScoreList)
        }
        else {
            print("Location is nil")
        }
    }
    
}

extension GameViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!! locationManager-didFailedWithError: \(error)")
        if(error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last!
        stopLocationManager()
        print("GOT IT! locationManager-didUpdateLocation: \(String(describing: location))")
    }
    
}
