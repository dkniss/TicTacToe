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
        
        stateMachine.enter(FirstPlayerInputState.self)
        
        gameboardView.onSelectPosition = { [unowned self] position in
            (self.stateMachine.currentState as? PlayerInputState)?.addMark(at: position)
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        recordEvent(.restartGame)
        
        self.stateMachine.enter(FirstPlayerInputState.self)
        self.gameboard.clear()
        self.gameboardView.clear()
    }
    
    private func configureStates() -> [GKState] {
        switch self.gameMode {
        case .playerVsAI:
            return [
                FirstPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                AIPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                GameEndedState(gameViewController: self)
            ]
        case .playerVsPlayer:
            return [
                FirstPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                SecondPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                GameEndedState(gameViewController: self)
            ]
        default:
            return [
                FirstPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                SecondPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                GameEndedState(gameViewController: self)
            ]
        }
    }
    
    func startNewGame() {
        self.stateMachine.enter(FirstPlayerInputState.self)
        self.gameboard.clear()
        self.gameboardView.clear()
    }
}
