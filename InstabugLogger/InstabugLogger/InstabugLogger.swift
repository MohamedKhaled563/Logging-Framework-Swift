//
//  InstabugLogger.swift
//  InstabugLogger
//
//  Created by Yosef Hamza on 19/04/2021.
//

import Foundation
import CoreData

public class InstabugLogger {
    public static var shared = InstabugLogger()
    var logger = Logger()

    // MARK: Logging
    public func log(_ level: Int64, message: String) {
        logger.addLogElement(message: message, level: level)
    }

    // MARK: Fetch logs
    public func fetchAllLogs() -> [LogElement]? {
        return logger.getLog()
    }
    
    public func deleteAllLogs() {
        logger.deleteLog()
    }
    
    public func fetchAllLogs(completionHandler: ([LogElement])->Void) {
        logger.getLogAndPerform(completionHandler: completionHandler)
    }
}
