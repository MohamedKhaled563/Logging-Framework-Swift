//
//  InstabugLoggerTests.swift
//  InstabugLoggerTests
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import XCTest
import CoreData
@testable import InstabugLogger

class InstabugLoggerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let container = NSPersistentContainer(name: "Log")
        let mainContext = container.viewContext
        let backgroundContext = container.newBackgroundContext()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDeletingAllLogs() {
        InstabugLogger.shared.deleteAllLogs()
        let log = InstabugLogger.shared.fetchAllLogs()
        var result = false
        if let safeLog = log {
            if (safeLog.count == 0) {
                result = true
            }
        }
        if (log == nil) {
            result = true
        }
        XCTAssertTrue(result)
    }
    
    
    func testAddingMessages() {
        InstabugLogger.shared.deleteAllLogs()
        InstabugLogger.shared.log(1, message: "Message1")
        var log = InstabugLogger.shared.fetchAllLogs()
        var result1 = false
        if(log?.count == 1) {
            let message = log?[0].message ?? ""
            result1 = message == "Message1"
        }
        XCTAssertTrue(result1)
        InstabugLogger.shared.deleteAllLogs()
        let invalidMessage = String(repeating: "A", count: 1001)
        InstabugLogger.shared.log(1, message: invalidMessage)
        log = InstabugLogger.shared.fetchAllLogs()
        let resultMessage = String(repeating: "A", count: 1000) + "..."
        let result2 = log?[0].message ?? "" == resultMessage
        XCTAssertTrue(result2)
    }
    
    
}
