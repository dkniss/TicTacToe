//
//  AIPlayerInputState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import GameplayKit

class AIPlayerInputState: PlayerInputState {
    // MARK: - Properties
    private let gameBoardSize = [0,1,2]
    
    // MARK: - Init
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .second, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
    
    // MARK: - Methods
    override func didEnter(from previousState: GKState?) {
        let randomPosition: GameboardPosition = {
            var position: GameboardPosition
            repeat {
                let randomRow = gameBoardSize.randomElement()
                let randomColumn = gameBoardSize.randomElement()
                let randomPosition = GameboardPosition(column: randomColumn!, row: randomRow!)
                position = randomPosition
            } while !self.view.canPlaceMarkView(at: position) && PlayerTurnInvoker.shared.commands.count < 9
            return position
        }()
        
        log.recordEvent(.addMark(self.player, randomPosition))
        recordTurn(player: self.player, position: randomPosition, gameboard: self.gameboard, view: self.view)
        
        placeMarkView(at: randomPosition)
    }
    
    override func checkForWinner() {
        if let winner = self.referee.determineWinner() {
            self.isWinner = winner == self.player
            self.stateMachine?.enter(GameEndedState.self)
        } else {
            let stateClass = player.next == .first ? FirstPlayerInputState.self : AIPlayerInputState.self
            self.stateMachine?.enter(stateClass)
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        switch self.player {
        case .first:
            self.gameViewController.firstPlayerTurnLabel.isHidden = false
            self.gameViewController.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController.firstPlayerTurnLabel.isHidden = true
            self.gameViewController.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController.winnerLabel.isHidden = true
    }
}
