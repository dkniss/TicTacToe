////
////  GameState.swift
////  XO-game
////
////  Created by v.prusakov on 4/12/21.
////  Copyright © 2021 plasmon. All rights reserved.
////
//
//import Foundation
//
//protocol GameState {
//    
//    var isCompleted: Bool { get }
//    
//    func begin()
//    
//    func addMark(at position: GameboardPosition)
//}
//
//class PlayerInputState: GameState {
//    
//    var isCompleted: Bool = false
//    
//    let player: Player
//    private unowned let gameViewController: GameViewController
//    private unowned let gameboard: Gameboard
//    private unowned let gameboardView: GameboardView
//    
//    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
//        self.player = player
//        self.gameViewController = gameViewController
//        self.gameboard = gameboard
//        self.gameboardView = gameboardView
//    }
//    
//    func begin() {
//        
//        switch player {
//        case .first:
//            self.gameViewController.firstPlayerTurnLabel.isHidden = false
//            self.gameViewController.secondPlayerTurnLabel.isHidden = true
//        case .second:
//            self.gameViewController.firstPlayerTurnLabel.isHidden = true
//            self.gameViewController.secondPlayerTurnLabel.isHidden = false
//        }
//        
//        self.gameViewController.winnerLabel.isHidden = true
//    }
//    
//    func addMark(at position: GameboardPosition) {
//        guard self.gameboardView.canPlaceMarkView(at: position) else { return }
//        
//        let mark = self.player == .first ? XView() : OView()
//        
//        self.gameboard.setPlayer(self.player, at: position)
//        self.gameboardView.placeMarkView(mark, at: position)
//        self.isCompleted = true
//    }
//    
//}
//
//class GameEndedState: GameState {
//    
//    let winner: Player?
//    unowned let gameViewController: GameViewController
//    
//    init(winner: Player?, gameViewController: GameViewController) {
//        self.winner = winner
//        self.gameViewController = gameViewController
//    }
//    
//    var isCompleted: Bool = false
//    
//    func begin() {
//        
//        self.gameViewController.winnerLabel.isHidden = false
//        if let player = self.winner {
//            self.gameViewController.winnerLabel.text = "\(self.winnerName(from: player)) win"
//        } else {
//            self.gameViewController.winnerLabel.text = "No winner"
//        }
//    }
//    
//    func addMark(at position: GameboardPosition) { }
//    
//    func winnerName(from player: Player) -> String {
//        player == .first ? "1st player" : "2nd player"
//    }
//}
