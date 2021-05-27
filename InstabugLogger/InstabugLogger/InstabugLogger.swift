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
    var logger: Logger!
    
    public func configure(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
            logger = Logger(mainContext: mainContext, backgroundContext: backgroundContext)
    }
    // MARK: Logging
    public func log(_ level: Int64, message: String) {
        logger.addLogElement(message: message, level: level)
    }

    // MARK: Fetch logs
    #warning("Replace Any with an appropriate type")
    public func fetchAllLogs() -> [LogElement]? {
        return logger.getLog()
    }
    
    public func deleteAllLogs() {
        if(logger != nil) {
            logger.deleteLog()
        }
    }
    
    #warning("Replace Any with an appropriate type")
    public func fetchAllLogs(completionHandler: (Any)->Void) {
        fatalError("Not implemented")
    }
}
