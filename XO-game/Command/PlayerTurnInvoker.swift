//
//  PlayerTurnInvoker.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class PlayerTurnInvoker {
    // MARK: - Properties
    static let shared = PlayerTurnInvoker()
    private let gameBoard = Gameboard()
    
    var commands: [PlayerTurnCommand] = []
    
    // MARK: - Methods
    func addCommand(_ command: PlayerTurnCommand) {
        self.commands.append(command)
    }
}
