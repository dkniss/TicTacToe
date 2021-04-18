//
//  PlayerTurnCommand.swift
//  XO-game
//
//  Created by Daniil Kniss on 18.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerTurnCommand {
    
    let player: Player
    let position: GameboardPosition
    let gameboard: Gameboard
    let view: GameboardView
    
    init(player: Player, position: GameboardPosition, gameboard: Gameboard, view: GameboardView) {
        self.player = player
        self.position = position
        self.gameboard = gameboard
        self.view = view
    }
    
    func execute() {
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: self.position)
        self.view.placeMarkView(markView, at: self.position)
    }
}

class PlayerTurnInvoker {
    static let shared = PlayerTurnInvoker()
    var commands: [PlayerTurnCommand] = []
    private let gameBoard = Gameboard()
    
    func addCommand(_ command: PlayerTurnCommand) {
        self.commands.append(command)
    }
}

func recordTurn(player: Player, position: GameboardPosition, gameboard: Gameboard, view: GameboardView) {
    let command = PlayerTurnCommand(player: player, position: position, gameboard: gameboard,view: view)
    PlayerTurnInvoker.shared.addCommand(command)
}
