//
//  LoggerStorageValidationService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import Foundation

// Validated the maximum number of stored elements <= maximumNumberOfElements
//
struct LoggerStorageValidationService {
    func checkStorageLimit(of elements: [LogElement]) -> Bool {
        let maximumNumberOfElements = 1000
        return elements.count > maximumNumberOfElements
    }
}
