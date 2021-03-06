//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import GameplayKit

class PlayerInputState: GKState {
    // MARK: - Properties
    unowned let gameViewController: GameViewController
    unowned let gameboard: Gameboard
    unowned let view: GameboardView
    unowned let referee: Referee
    
    let player: Player
    let log = AnalyticsLogInvoker.shared
    var isWinner: Bool = false
    
    // MARK: - Init
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, view: GameboardView, referee: Referee) {
        self.player = player
        self.gameboard = gameboard
        self.view = view
        self.gameViewController = gameViewController
        self.referee = referee
    }
    
    // MARK: - Methods
    override func didEnter(from previousState: GKState?) {
        setupUI()
    }
    
    func addMark(at position: GameboardPosition) {
        guard self.view.canPlaceMarkView(at: position) else { return }
        log.recordEvent(.addMark(self.player, position))
        
        recordTurn(player: self.player, position: position, gameboard: self.gameboard, view: self.view)
        
        placeMarkView(at: position)
        
        checkForWinner()
    }
    
    func recordTurn(player: Player, position: GameboardPosition, gameboard: Gameboard, view: GameboardView) {
        let command = PlayerTurnCommand(player: player, position: position, gameboard: gameboard,view: view)
        PlayerTurnInvoker.shared.addCommand(command)
    }
    
    func placeMarkView(at position: GameboardPosition) {
        let markView = self.player == .first ? XView() : OView()
        self.gameboard.setPlayer(self.player, at: position)
        self.view.placeMarkView(markView, at: position)
    }
    
    func checkForWinner() {
        if let winner = self.referee.determineWinner() {
            self.isWinner = winner == self.player
            self.stateMachine?.enter(GameEndedState.self)
        } else {
            if PlayerTurnInvoker.shared.commands.count < 9 {
                switch gameViewController.gameMode {
                case .playerVsAI:
                    let stateClass = player.next == .first ? FirstPlayerInputState.self : AIPlayerInputState.self
                    self.stateMachine?.enter(stateClass)
                case .playerVsPlayer:
                    let stateClass = player.next == .first ? FirstPlayerInputState.self : SecondPlayerInputState.self
                    self.stateMachine?.enter(stateClass)
                case .blindPlay:
                    let stateClass = player.next == .first ? BlindFirstPlayerInputState.self : BlindSecondPlayerInputState.self
                    self.stateMachine?.enter(stateClass)
                default:
                    break
                }
            } else {
                self.stateMachine?.enter(GameEndedState.self)
            }
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
