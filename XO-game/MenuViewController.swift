//
//  MenuViewController.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

enum GameMode {
    case playerVsPlayer, playerVsAI
}

class MenuViewController: UIViewController {
    
    var gameMode: GameMode = .playerVsPlayer
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playerVsPlayerButton: UIButton! {
        didSet {
            self.playerVsPlayerButton.layer.cornerRadius = 15
            self.playerVsPlayerButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var playerVsAIButton: UIButton! {
        didSet {
            self.playerVsAIButton.layer.cornerRadius = 15
            self.playerVsAIButton.clipsToBounds = true
        }
    }
    
    
    @IBAction func startGamePlayerVsPlayer(_ sender: Any) {
        self.gameMode = .playerVsPlayer
        performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    @IBAction func startGamePlayerVsAI(_ sender: Any) {
        self.gameMode = .playerVsAI
        performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "StartGameSegue",
            let destinationVC = segue.destination as? GameViewController
        else { return }
        
        destinationVC.gameMode = gameMode
    }


}
