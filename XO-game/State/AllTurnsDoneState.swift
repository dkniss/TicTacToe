//
//  AllTurnsDoneState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import GameplayKit

class AllTurnsDoneState: GKState {
    // MARK: - Properties
    var isWinner: Bool = false
    var player: Player?
    
    unowned let gameViewController: GameViewController
    private let turnsRange = 0...4
    
    // MARK: - Init
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    // MARK: - Methods
    override func didEnter(from previousState: GKState?) {
        setupUI()
        executeCommands()
        checkForWinner()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        self.gameViewController.firstPlayerTurnLabel.isHidden = true
        self.gameViewController.secondPlayerTurnLabel.isHidden = true
        self.gameViewController.winnerLabel.isHidden = false
        self.gameViewController.winnerLabel.text = "Подводим итоги..."
    }
    
    private func executeCommands() {
        let commands = PlayerTurnInvoker.shared.commands
        let xCommands = commands.filter({$0.player == .first})
        let oCommands = commands.filter({$0.player == .second})
        
        for turn in turnsRange {
            xCommands[turn].execute()
            oCommands[turn].execute()
        }
    }
    
    private func checkForWinner() {
        if let winner = self.gameViewController.referee.determineWinner() {
            self.player = winner
            self.isWinner.toggle()
            self.stateMachine?.enter(GameEndedState.self)
        } else {
            self.gameViewController.winnerLabel.text = "Ничья"
            self.gameViewController.showAlert(title: "Игра окончена", message: "Ничья") { [weak self] in
                guard let self = self else { return }
                self.gameViewController.startNewGame()
            }
        }
    }
}
