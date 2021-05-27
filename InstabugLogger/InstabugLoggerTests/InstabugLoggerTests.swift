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
        InstabugLogger.shared.configure(mainContext: mainContext, backgroundContext: backgroundContext)
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
                result = false
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
        let log = InstabugLogger.shared.fetchAllLogs()
        if(log?.count == 1) {
            XCTAssertTrue(log?[0].message ?? "" == "Message1")
        }
        InstabugLogger.shared.deleteAllLogs()
        let invalidMessage = String(repeating: "A", count: 1001)
        InstabugLogger.shared.log(1, message: invalidMessage)
        let resultMessage = String(repeating: "A", count: 999) + "..."
        XCTAssertTrue(log?[0].message ?? "" == resultMessage)
    }
    
    
}
