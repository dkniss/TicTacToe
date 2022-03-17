//
//  AIPlayerInputState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import GameplayKit

class AIPlayerInputState: PlayerInputState {
    // MARK: - Init
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .second, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
    
    // MARK: - Methods
    override func didEnter(from previousState: GKState?) {
        switch self.player {
        case .first:
            self.gameViewController.firstPlayerTurnLabel.isHidden = false
            self.gameViewController.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController.firstPlayerTurnLabel.isHidden = true
            self.gameViewController.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController.winnerLabel.isHidden = true
        
        let GameBoardSize = [0,1,2]
        
        let randomPosition: GameboardPosition = {
            var position: GameboardPosition
            repeat {
                let randomRow = GameBoardSize.randomElement()
                let randomColumn = GameBoardSize.randomElement()
                let randomPosition = GameboardPosition(column: randomColumn!, row: randomRow!)
                position = randomPosition
            } while !self.view.canPlaceMarkView(at: position) && PlayerTurnInvoker.shared.commands.count < 9
            return position
        }()
        
        recordEvent(.addMark(self.player, randomPosition))
        
        recordTurn(player: self.player, position: randomPosition, gameboard: self.gameboard, view: self.view)
        
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: randomPosition)
        self.view.placeMarkView(markView, at: randomPosition)
        
        if let winner = self.referee.determineWinner() {
            self.isWinner = winner == self.player
            self.stateMachine?.enter(GameEndedState.self)
        } else {
            let stateClass = player.next == .first ? FirstPlayerInputState.self : AIPlayerInputState.self
            self.stateMachine?.enter(stateClass)
        }
    }
}
