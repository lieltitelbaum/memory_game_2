//
//  Game.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import Foundation
import UIKit

class Game{
    
    private var pairedSuccessfully: Int = 0//how many cards are paired
    private var score = 0
    private var isPlaying = false
    private var isTimerOn = false
    private var imagesCounter = Array(repeating: 0, count: 10)
    private var imageInPlace: [(image: UIImage, isOpen: Bool)] = []//array of tuple of image and if the card is open -> the index represent the card tag(simulate its' location)
    private var cards: [UIButton] = []
    private var timer = Timer()
    private var numOfMoves: Int = 20
    //Const
    private let images = [#imageLiteral(resourceName: "ic_chicken") ,#imageLiteral(resourceName: "ic_burger") ,#imageLiteral(resourceName: "ic_fries") ,#imageLiteral(resourceName: "ic_broccoli") ,#imageLiteral(resourceName: "ic_chocolate") ,#imageLiteral(resourceName: "ic_sushi") ,#imageLiteral(resourceName: "ic_cake") ,#imageLiteral(resourceName: "ic_pizza")]
    private let backCard = #imageLiteral(resourceName: "ic_back_card")
    private let cardMatrixSize = 20 //5*4
    private let numOfImageDuplicate = 2
    private let gameMoves = 20
    
    
    //functions
    public func getMovesNum() -> Int{
        return self.gameMoves;
    }
    
    public func getCurrentPlayerMoves() -> Int {
        return self.numOfMoves
    }
    
    public func getScore() -> Int {
        return self.score
    }
    
    public func getPlayingStatus() -> Bool {
        return self.isPlaying
    }
    
    public func setPlayingStatus(status: Bool) {
        self.isPlaying = status
    }
    
    public func setCurrentPlayerMoves(moves: Int){
        self.numOfMoves = moves
    }
    
    public func resetGameMoves() {
        self.numOfMoves = 0
    }
    
    public func setScore(score: Int){
        self.score = score
    }
    
    public func initGameProperties() {
        self.score = 0
        self.pairedSuccessfully = 0
        self.numOfMoves = gameMoves
    }
    
    public func resetCards() {
        for i in 0..<imagesCounter.count {
            imagesCounter[i] = 0
        }
        imageInPlace.removeAll()//remove all current card to image randomly allocations
    }
    
    public func shuffleCards() {
        var rndCardImg: Int
        //tag is the index i in the imageInPlace array
        //image counter represent how many times image is being assign -> need only twice
        for _ in 0..<cardMatrixSize {
            //checking if the image is presented twice
            repeat{
                rndCardImg = Int.random(in: 0 ..< images.count)
            } while (imagesCounter[rndCardImg] >= numOfImageDuplicate); //if the image already been place twice-> rand different image
            //puts in imageInPlace in index (=button tag) the image that has been selected randomly
            imageInPlace.append((image: images[rndCardImg], isOpen: false))
            imagesCounter[rndCardImg] += 1
        }
    }
    
    func checkMatch(previous: UIButton, current: UIButton) -> Bool{
        if(imageInPlace[previous.tag].image == imageInPlace[current.tag].image && previous.tag != current.tag && imageInPlace[previous.tag].isOpen && imageInPlace[current.tag].isOpen){
            //if the images are the same and the tag(=index) of the card is different and the cards are open
            pairedSuccessfully += 1
            previous.isEnabled = false
            current.isEnabled = false
            score += 10 //add 10 points when cards are being paired successfully
            return true //returns true if the cards are match
        }
        else {
            if(previous.tag != current.tag){ //if user press on two cards that are not a pair and not on the same card twice
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.closeCard(card: previous)
                    self.closeCard(card: current)
                    //return false when card are not match
                }
            }
        }
        return false
    }
    
    func openCard(card: UIButton){
        card.setImage(imageInPlace[card.tag].image, for: .normal)
        imageInPlace[card.tag].isOpen = true
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
    }
    
    func closeCard(card: UIButton){
        card.setImage(backCard, for: .normal)
        imageInPlace[card.tag].isOpen = false
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func setTimer(on: Bool, timerLabel: UILabel){
        if(on) {//run timer each second
            var duration = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                duration += 1
                self.isTimerOn = true //on status
                timerLabel.text = String(duration) + " S"
            }
        }
        else {
            timer.invalidate()//pause
            self.isTimerOn = false//pause status
        }
    }
    
    func getTimerStatus() -> Bool{
        return self.isTimerOn
    }
    
    public func checkIfWinner(playBtn: UIButton, timerLbl: UILabel){//check if the user lost or won
        if(pairedSuccessfully == cardMatrixSize/numOfImageDuplicate) {//if the user matched all of the cards-> he wons
            setGameWhenStop(winnerStatus: true, playBtn: playBtn, timerLbl: timerLbl)
        }
        else if(numOfMoves == 0){//if he lost -> ran out of moves
            setGameWhenStop(winnerStatus: false, playBtn: playBtn, timerLbl: timerLbl)
        }
    }
    
    private func setGameWhenStop(winnerStatus: Bool, playBtn: UIButton, timerLbl: UILabel) {
        setTimer(on: false, timerLabel: timerLbl)//pause timer
        playBtn.isHidden = false
        isPlaying = false
        if(winnerStatus) {
            playBtn.setTitle("YOU WON!\nPlay again", for: .normal)
        }
        else {
            playBtn.setTitle("YOU LOST\nPlay again", for: .normal)
        }
    }
}

