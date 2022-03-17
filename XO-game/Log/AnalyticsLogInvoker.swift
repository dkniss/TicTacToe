//
//  AnalyticsLogInvoker.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class AnalyticsLogInvoker {
    // MARK: - Properties
    static let shared = AnalyticsLogInvoker()
    
    private var command: [LogCommand] = []
    private var batchCount: Int = 5
    
    private let logger: Logger = Logger() // Receiver
    
    // MARK: - Methods
    func addCommand(_ command: LogCommand) {
        self.command.append(command)
        self.executeCommandsIfNeeded()
    }
    
    func recordEvent(_ event: LogEvent) {
        let command = LogCommand(event: event)
        addCommand(command)
    }
    
    //MARK: - Private methods
    private func executeCommandsIfNeeded() {
        guard self.command.count >= self.batchCount else { return }
        self.command.forEach {
            self.logger.writeLogMessage($0.logMessage)
        }
        
        self.command.removeAll()
    }
}
