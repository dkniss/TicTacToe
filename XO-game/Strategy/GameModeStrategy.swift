//
//  GameModeStrategy.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation
import GameplayKit

protocol GameModeStrategy {
    var gameViewController: GameViewController? { get }
    
    func configureStates() -> [GKState]?
}
