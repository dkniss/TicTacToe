//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    let gameboard = Gameboard()
    lazy var referee = Referee(gameboard: self.gameboard)
    
    var stateMachine: GKStateMachine!
    
    var gameMode: GameMode?
    
    var startState: AnyClass {
        switch self.gameMode {
        case .blindPlay:
            return BlindFirstPlayerInputState.self
        default:
            return FirstPlayerInputState.self
        }
    }
    
    var gameModeStrategy: GameModeStrategy {
        switch gameMode {
        case .playerVsAI:
            return PlayerVsAIStrategy()
        case .playerVsPlayer:
            return PlayerVsPlayerStrategy()
        case .blindPlay:
            return BlindPlayStrategy()
        default:
            return PlayerVsPlayerStrategy()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let states = gameModeStrategy.configureStates(gameViewController: self)
 
        self.stateMachine = GKStateMachine(states: states)
        
        startNewGame()

        gameboardView.onSelectPosition = { [unowned self] position in
            (self.stateMachine.currentState as? PlayerInputState)?.addMark(at: position)
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        recordEvent(.restartGame)
        startNewGame()
    }
    
    func startNewGame() {
        PlayerTurnInvoker.shared.commands = []
        self.stateMachine.enter(startState)
        self.gameboard.clear()
        self.gameboardView.clear()
    }
}
