//
//  GKState.swift
//  XO-game
//
//  Created by v.prusakov on 4/12/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation
import GameplayKit

class GameEndedState: GKState {

    var winner: Player?

    unowned let gameViewController: GameViewController

    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }

    override func didEnter(from previousState: GKState?) {
        self.gameViewController.winnerLabel.isHidden = false

        if let playerInput = previousState as? PlayerInputState, playerInput.isWinner {
            recordEvent(.endGame(winner: playerInput.player))
            
            var message = ""
            
            switch playerInput.player {
            case .first:
                message = "первый"
            case .second:
                message = "второй"
            }
            
            self.gameViewController.winnerLabel.text = self.winnerName(from: playerInput.player) + " win"
            let alertVC = UIAlertController(title: "Игра окончена!", message: "Победил \(message) игрок", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) { _ in
                self.gameViewController.dismiss(animated: true)
            }
            alertVC.addAction(action)
            self.gameViewController.present(alertVC, animated: true)
        } else {
            self.gameViewController.winnerLabel.text = "No winner"
        }
        self.gameViewController.firstPlayerTurnLabel.isHidden = true
        self.gameViewController.secondPlayerTurnLabel.isHidden = true
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == FirstPlayerInputState.self
    }

    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2nd player"
        }
    }
}

class PlayerInputState: GKState {
    let player: Player
    unowned let gameViewController: GameViewController
    unowned let gameboard: Gameboard
    unowned let view: GameboardView
    unowned let referee: Referee

    var isWinner: Bool = false

    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        self.player = player
        self.gameboard = gameboard
        self.view = view
        self.gameViewController = gameViewController
        self.referee = referee
    }

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
    }

    func addMark(at position: GameboardPosition) {
        guard self.view.canPlaceMarkView(at: position) else { return }
        
        recordEvent(.addMark(self.player, position))
        
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: position)
        self.view.placeMarkView(markView, at: position)

        if let winner = self.referee.determineWinner() {
            self.isWinner = winner == self.player
            self.stateMachine?.enter(GameEndedState.self)
        } else {
            if gameViewController.gameMode == .playerVsAI {
                let stateClass = player.next == .first ? FirstPlayerInputState.self : AIPlayerInputState.self
                self.stateMachine?.enter(stateClass)
            } else {
                let stateClass = player.next == .first ? FirstPlayerInputState.self : SecondPlayerInputState.self
                self.stateMachine?.enter(stateClass)
            }
        }
    }
}

class SecondPlayerInputState: PlayerInputState {
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .second, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
}

class FirstPlayerInputState: PlayerInputState {
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .first, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
}

class AIPlayerInputState: PlayerInputState {
    init(gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        super.init(player: .second, gameViewController: gameViewController, gameboard: gameboard, view: view, referee: referee)
    }
    
    override func addMark(at position: GameboardPosition) {
        
        let GameBoardSize = [0,1,2]
//        guard
//            let randomRow = GameBoardSize.randomElement(),
//            let randomColumn = GameBoardSize.randomElement()
//        else { return }
        
//        let randomPosition = GameboardPosition(column: randomColumn, row: randomRow)
        
        let randomPosition: GameboardPosition = { 
            var position: GameboardPosition
            repeat {
                let randomRow = GameBoardSize.randomElement()
                let randomColumn = GameBoardSize.randomElement()
                let randomPosition = GameboardPosition(column: randomColumn!, row: randomRow!)
                position = randomPosition
            } while !self.view.canPlaceMarkView(at: position)
            return position
            
        }()
        
        guard self.view.canPlaceMarkView(at: randomPosition) else { return }
        
        recordEvent(.addMark(self.player, randomPosition))
        
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
