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
    
    private let gameboard = Gameboard()    
    lazy var referee = Referee(gameboard: self.gameboard)
    
    var stateMachine: GKStateMachine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateMachine = GKStateMachine(states:
                                            [
                                                FirstPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                                                SecondPlayerInputState(gameViewController: self, gameboard: self.gameboard, view: self.gameboardView, referee: self.referee),
                                                GameEndedState(gameViewController: self)
                                            ]
        )
        
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
}
