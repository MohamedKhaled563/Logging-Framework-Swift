//
//  LoggerStorageValidationService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import Foundation

struct LoggerStorageValidationService {
    func checkStorageLimit(of elements: [LogElement]) -> Bool {
        return elements.count > 1000
    }
}
