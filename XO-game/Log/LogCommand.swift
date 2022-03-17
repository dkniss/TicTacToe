//
//  LogCommand.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

enum LogEvent {
    case addMark(Player, GameboardPosition)
    case endGame(winner: Player)
    case restartGame
}

class LogCommand {
    let event: LogEvent
    
    var logMessage: String {
        switch self.event {
        case let .addMark(player, position):
            return "Player \(player) did add mark view at position: \(position)"
        case .endGame(let winner):
            return "Player \(winner) is win"
        case .restartGame:
            return "Game was restarted"
        }
    }
    
    init(event: LogEvent) {
        self.event = event
    }
}
