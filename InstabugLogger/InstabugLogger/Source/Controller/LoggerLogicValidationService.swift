//
//  LoggerLogicValidationService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import Foundation

struct LoggerLogicValidationService {
    func validateMessage(_ message: String) -> Bool{
        return message.count > 1000
    }
}
