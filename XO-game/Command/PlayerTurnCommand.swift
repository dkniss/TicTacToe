//
//  PlayerTurnCommand.swift
//  XO-game
//
//  Created by Daniil Kniss on 18.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerTurnCommand {
    // MARK: - Properties
    let player: Player
    let position: GameboardPosition
    let gameboard: Gameboard
    let view: GameboardView
    
    // MARK: - Init
    init(player: Player, position: GameboardPosition, gameboard: Gameboard, view: GameboardView) {
        self.player = player
        self.position = position
        self.gameboard = gameboard
        self.view = view
    }
    
    // MARK: - Methods
    func execute() {
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: self.position)
        self.view.placeMarkView(markView, at: self.position)
    }
}
