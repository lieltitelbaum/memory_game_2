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

    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.setNavigationBarHidden(true,animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false,animated: false)
    }

    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayGame", sender: self)
    }
    
    @IBAction func startTopTen(_ sender: UIButton) {
        performSegue(withIdentifier: "TopTen", sender: self)
    }
}

