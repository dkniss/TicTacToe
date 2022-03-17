//
//  GameEndedState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import GameplayKit

class GameEndedState: GKState {
    // MARK: - Properties
    var winner: Player?
    
    unowned let gameViewController: GameViewController
    
    // MARK: - Init
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    // MARK: - Methods
    override func didEnter(from previousState: GKState?) {
        setupUI()
        
        if let playerInput = previousState as? PlayerInputState, playerInput.isWinner {
            recordEvent(.endGame(winner: playerInput.player))
            showWinner(player: playerInput.player)
        } else if let playerInput = previousState as? AllTurnsDoneState {
            guard let player = playerInput.player else { return }
            recordEvent(.endGame(winner: player))
            showWinner(player: player)
        } else {
            self.gameViewController.winnerLabel.text = "Ничья"
            let alertVC = UIAlertController(title: "Игра окончена", message: "Ничья", preferredStyle: .alert)
            let action =  UIAlertAction(title: "Ок", style: .default) { _ in
                self.gameViewController.startNewGame()
            }
            alertVC.addAction(action)
            self.gameViewController.present(alertVC, animated: true)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == FirstPlayerInputState.self
    }
    
    // MARK: - Private methods
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2nd player"
        }
    }
    
    private func setupUI() {
        self.gameViewController.winnerLabel.isHidden = false
        self.gameViewController.firstPlayerTurnLabel.isHidden = true
        self.gameViewController.secondPlayerTurnLabel.isHidden = true
    }
    
    private func showWinner(player: Player) {
        self.gameViewController.winnerLabel.text = self.winnerName(from: player) + " win"
        
        let message = player == .first ? "первый" : "второй"
        
        let alertVC = UIAlertController(title: "Игра окончена!", message: "Победил \(message) игрок", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            self.gameViewController.startNewGame()
        }
        alertVC.addAction(action)
        self.gameViewController.present(alertVC, animated: true)
    }
}
