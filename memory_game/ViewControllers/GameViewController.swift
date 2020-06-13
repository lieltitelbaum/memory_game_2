//
//  GameViewController.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/05/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //vars
    @IBOutlet var game_BTN_cards: [UIButton]!//collection of all the card buttons
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_score: UILabel!
    @IBOutlet weak var game_BTN_play: UIButton!
    
    private var previousButton: UIButton!
    
    private var game = Game()
    private var counter: Int = 0//pressing cards counter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameLabels()
    }
    
    func setGameLabels() {
        game_LBL_moves.text = String(game.getMovesNum())
        game_LBL_timer.text = String(0) + " S"
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
        if(game.checkMatch(previous: previous, current: current)) {
            game.setScore(score: game.getScore() + 10)
            game_LBL_score.text = "Score: " + String(game.getScore())
        }
    }
    
    @IBAction func clickPlayGame(_ sender: UIButton){//when play is being clicked
        if(!game.getPlayingStatus()) {
            initGame()
            game_BTN_play.isHidden = true
            game.setPlayingStatus(status: true)
        }
        else {
            game.setPlayingStatus(status: false)
            game_BTN_play.isHidden = false
        }
    }

    @IBAction func button_clicked(_ sender: UIButton){
        if(game.getPlayingStatus()) {
            counter += 1 //amount of button clicks
//             print(game.getCurrentPlayerMoves())
            game.openCard(card: sender)
            
            if(counter % 2 == 0){
                if(sender != previousButton){
                    game.setCurrentPlayerMoves(moves: game.getCurrentPlayerMoves() - 1)
                    print(game.getCurrentPlayerMoves())
                    game_LBL_moves.text = String(game.getCurrentPlayerMoves())
                    isCardsMatch(previous: previousButton, current: sender)
                }
                else{//if the user click on the same card- don't count the number of moves
                    counter = 1
                }
            }
            previousButton = sender
    
            game.checkIfWinner(playBtn: game_BTN_play, timerLbl: game_LBL_timer)
        
        }
    }
    
}
