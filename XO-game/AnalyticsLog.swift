//
//  AnalyticsLog.swift
//  XO-game
//
//  Created by v.prusakov on 4/12/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum LogEvent {
    case addMark(Player, GameboardPosition)
    case endGame(winner: Player)
    case restartGame
}

class LogCommand {
    
    let event: LogEvent
    
    init(event: LogEvent) {
        self.event = event
    }
    
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
}

class Logger {
    func writeLogMessage(_ message: String) {
        print(message)
    }
}


class AnalyticsLogInvoker {
    
    static let shared = AnalyticsLogInvoker()
    
    private var command: [LogCommand] = []
    private var batchCount: Int = 6
    
    private let logger: Logger = Logger() // Receiver
    
    func addCommand(_ command: LogCommand) {
        self.command.append(command)
        self.executeCommandsIfNeeded()
    }
    
    private func executeCommandsIfNeeded() {
        guard self.command.count >= self.batchCount else { return }
        self.command.forEach {
            self.logger.writeLogMessage($0.logMessage)
        }
        
        self.command.removeAll()
    }
}

func recordEvent(_ event: LogEvent) {
    let command = LogCommand(event: event)
    AnalyticsLogInvoker.shared.addCommand(command)
}
