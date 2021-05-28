//
//  LoggerService.swift
//  InstabugInternshipTask
//
//  Created by Mohamed Khalid on 25/05/2021.
//

import UIKit
import CoreData

// Responsible for dealing with CoreData
//
struct LoggerService {
    var savedElements: [LogElement]?
    let validation = LoggerStorageValidationService()
    
    init() {
        backgroundContext.performAndWait {
            savedElements = fetch()
        }
    }
    
    //Single background context to be shared between all background threads
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let instabugLoggerBundle = Bundle(identifier: "com.MohamedKhaled.InstabugLogger")
        let modelURL = instabugLoggerBundle!.url(forResource: "Log", withExtension: ".momd")
        let container = NSPersistentContainer(name: "Log", managedObjectModel: NSManagedObjectModel(contentsOf: modelURL!)!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    mutating func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
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
    
    mutating func fetchAndPerform(completionHandler: ([LogElement]) -> Void) {
        let log = fetch()
        if let safeLog = log {
            completionHandler(safeLog)
        }
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
    
    // Ensures that saved items doesn't exceed 1000 element
    //
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
    
    mutating func deleteEarliestElement(_ elements: inout [LogElement]) {
        backgroundContext.performAndWait {
            // Sort the elements array in order to execute the function in o(sort) rather than o(n^2)
            elements.sort {
                $0.timestamp ?? Date() > $1.timestamp ?? Date()
            }
            // Deleting in o(1)
            backgroundContext.delete(elements.last!)
            elements.removeLast()
        }
    }
}
