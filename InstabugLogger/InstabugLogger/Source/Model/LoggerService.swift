//
//  LoggerService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 25/05/2021.
//

import UIKit
import CoreData

struct LoggerService {
    var savedElements: [LogElement]?
    let validation = LoggerStorageValidationService()
    var mainContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        backgroundContext.performAndWait {
            savedElements = fetch()
        }
    }
    mutating func insert(message: String, level: Int64, timeSpam: Date) {
        backgroundContext.performAndWait {
            let logElement = LogElement(context: backgroundContext)
            logElement.message = message
            logElement.level = level
            logElement.timestamp = timeSpam
            logElement.identifier = UUID()
            backgroundContext.insert(logElement)
            savedElements?.append(logElement)
            checkStorageLimit()
        }
    }
    
    mutating func fetch() -> [LogElement]?{
        backgroundContext.performAndWait {
            let fetchRequest:NSFetchRequest<LogElement> = LogElement.fetchRequest()
            do {
                savedElements = try backgroundContext.fetch(fetchRequest)
            } catch {
                print(error)
            }
        }
        return savedElements
    }
    
    mutating func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LogElement.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try backgroundContext.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
    mutating func checkStorageLimit() {
        backgroundContext.performAndWait {
            if var elements = savedElements {
                if (validation.checkStorageLimit(of: elements)) {
                    deleteEarliestElement(&elements)
                }
            }
            do {
                try backgroundContext.save()
            } catch  {
                print(error)
            }
        }
    }
    
    func deleteEarliestElement(_ elements: inout [LogElement]) {
        backgroundContext.performAndWait {
            elements.sort {
                $0.timestamp! > $1.timestamp!
            }
            backgroundContext.delete(elements.last!)
            elements.removeLast()
        }
    }
}
