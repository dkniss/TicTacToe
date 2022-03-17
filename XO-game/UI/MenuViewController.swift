//
//  MenuViewController.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

enum GameMode {
    case playerVsPlayer, playerVsAI,blindPlay
}

class MenuViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playerVsPlayerButton: UIButton!
    @IBOutlet weak var playerVsAIButton: UIButton!
    @IBOutlet weak var blindPlayButton: UIButton!
    
    // MARK: - Properties
    var gameMode: GameMode = .playerVsPlayer
    
    // MARK: - IBActions
    @IBAction func startGamePlayerVsPlayer(_ sender: Any) {
        self.gameMode = .playerVsPlayer
        performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    @IBAction func startGamePlayerVsAI(_ sender: Any) {
        self.gameMode = .playerVsAI
        performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    @IBAction func startGameBlindPlay(_ sender: Any) {
        self.gameMode = .blindPlay
        performSegue(withIdentifier: "StartGameSegue", sender: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
            let destinationVC = segue.destination as? GameViewController else { return }
        destinationVC.gameMode = gameMode
    }
    
    // MARK: - Private methods
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let buttons = [self.playerVsPlayerButton, self.playerVsAIButton, self.blindPlayButton]
        buttons.forEach({ button in
            button?.layer.cornerRadius = 12
            button?.clipsToBounds = true
        })
    }
}
