//
//  BlindPlayStrategy.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import GameplayKit

class BlindPlayStrategy: GameModeStrategy {
    func configureStates(gameViewController: GameViewController) -> [GKState] {
        let states = [
            BlindFirstPlayerInputState(gameViewController: gameViewController,
                                       gameboard: gameViewController.gameboard,
                                       view: gameViewController.gameboardView,
                                       referee: gameViewController.referee),
            
            BlindSecondPlayerInputState(gameViewController: gameViewController,
                                        gameboard: gameViewController.gameboard,
                                        view: gameViewController.gameboardView,
                                        referee: gameViewController.referee),
            
            AllTurnsDoneState(gameViewController: gameViewController),
            GameEndedState(gameViewController: gameViewController)
        ]
        return states
    }
}
