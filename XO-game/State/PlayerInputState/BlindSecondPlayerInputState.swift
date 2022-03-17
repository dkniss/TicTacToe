//
//  BlindSecondPlayerInputState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class BlindSecondPlayerInputState: PlayerInputState {
    // MARK: - Init
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .second, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
    
    // MARK: - Methods
    override func addMark(at position: GameboardPosition) {
        
        recordEvent(.addMark(self.player, position))
        
        recordTurn(player: self.player, position: position, gameboard: self.gameboard, view: self.view)
        
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: position)
        self.view.placeMarkView(markView, at: position)
        
        if PlayerTurnInvoker.shared.commands.count >= 10 {
            let alertVC = UIAlertController(title: "Конец хода", message: "Пора подвести итоги", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) { _ in
                self.gameboard.clear()
                self.view.clear()
                self.stateMachine?.enter(AllTurnsDoneState.self)
            }
            alertVC.addAction(action)
            gameViewController.present(alertVC, animated: true)
        }
    }
}
