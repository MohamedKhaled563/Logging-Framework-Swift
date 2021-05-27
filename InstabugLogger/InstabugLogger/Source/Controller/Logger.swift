//
//  Logger.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 25/05/2021.
//

import Foundation
import CoreData

struct Logger {
    var loggerService = LoggerService()
    let validation = LoggerLogicValidationService()
    
    mutating func addLogElement(message: String, level: Int64) {
        var verifiedMessage = message
        validateMessage(message: &verifiedMessage)
        loggerService.insert(message: verifiedMessage, level: level, timeSpam: Date())
    }

    func validateMessage(message: inout String) {
        if (validation.validateMessage(message)) {
            let lastIndex = message.index(message.startIndex, offsetBy: 999)
            message = message[message.startIndex...lastIndex] + "..."
        }
    }

    mutating func getLog() -> [LogElement]? {
        return loggerService.fetch()
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
