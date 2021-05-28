//
//  LoggerLogicValidationService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import Foundation

// Validate the message length <= maximumNumberOfCharacters
//
struct LoggerLogicValidationService {
    func validateMessage(_ message: String) -> Bool{
        let maximumNumberOfCharacters = 1000
        return message.count > maximumNumberOfCharacters
    }
}
