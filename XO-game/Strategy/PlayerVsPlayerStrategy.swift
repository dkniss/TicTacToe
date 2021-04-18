//
//  PlayerVsPlayerStrategy.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerVsPlayerStrategy: GameModeStrategy {
 
    func configureStates(gameViewController: GameViewController) -> [GKState] {
        
        let states = [
            FirstPlayerInputState(gameViewController: gameViewController, gameboard: gameViewController.gameboard, view: gameViewController.gameboardView, referee: gameViewController.referee),
            SecondPlayerInputState(gameViewController: gameViewController, gameboard: gameViewController.gameboard, view: gameViewController.gameboardView, referee: gameViewController.referee),
            GameEndedState(gameViewController: gameViewController)
        ]
        return states
    }
}



