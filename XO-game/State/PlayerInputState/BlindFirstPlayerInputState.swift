//
//  BlindFirstPlayerInputState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class BlindFirstPlayerInputState: PlayerInputState {
    // MARK: - Init
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .first, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
    
    // MARK: - Methods
    override func addMark(at position: GameboardPosition) {
        recordEvent(.addMark(self.player, position))
        recordTurn(player: self.player, position: position, gameboard: self.gameboard, view: self.view)
        
        placeMarkView(at: position)
        
        guard PlayerTurnInvoker.shared.commands.count >= 5 else { return }
        
        gameViewController.showAlert(title: "Конец хода", message: "Ход переходит следующему игроку") { [weak self] in
            guard let self = self else { return }
            let stateClass = self.player.next == .first ? BlindFirstPlayerInputState.self : BlindSecondPlayerInputState.self
            self.gameboard.clear()
            self.view.clear()
            self.stateMachine?.enter(stateClass)
        }
    }
}
