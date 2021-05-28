//
//  Logger.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 25/05/2021.
//

import Foundation
import CoreData

struct Logger {
    // Properties
    //
    var loggerService = LoggerService()
    let validation = LoggerLogicValidationService()
    
    // Methods
    //
    
    // Add element to the log
    //
    mutating func addLogElement(message: String, level: Int64) {
        var verifiedMessage = message
        validateMessage(message: &verifiedMessage)
        loggerService.insert(message: verifiedMessage, level: level, timeSpam: Date())
    }
    
    // Validate the message length --> if size > 1000, replace the rest with "..."
    //
    func validateMessage(message: inout String) {
        if (validation.validateMessage(message)) {
            let maximumNumberOfCharacters = 1000
            let lastIndex = message.index(message.startIndex, offsetBy: maximumNumberOfCharacters - 1)
            message = message[message.startIndex...lastIndex] + "..."
        }
    }

    // Returns saved log
    //
    mutating func getLog() -> [LogElement]? {
        return loggerService.fetch()
    }

    // Returns saved log and performs the passes completion handler
    //
    mutating func getLogAndPerform(completionHandler: ([LogElement])->Void ) {
        let log = getLog()
        if let safeLog = log {
            completionHandler(safeLog)
        }
    }
    
    mutating func printLog() {
        let log = getLog()
        if let safeLog = log {
            for logElement in safeLog {
                print ("Message: \(logElement.message)\nLevel: \(logElement.level)\nTimestamp: \(logElement.timestamp)\n")
                print("________________________________\n")
            }
        }
    }

    mutating func deleteLog() {
        loggerService.deleteAll()
    }
}
