//
//  MainViewController.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var top_ten_btn: UIButton!
    @IBOutlet weak var start_game_btn: UIButton!
    
    private let segueStartGameId = "game"
    private let segueStartTopTenId = "topTen"
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: segueStartGameId, sender: self)
    }
    
    @IBAction func startTopTen(_ sender: UIButton) {
        performSegue(withIdentifier: segueStartTopTenId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
