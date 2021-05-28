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

    // Testing deleting all logs functionality
    //
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
    
    // Tests fetching all data from the log and checks it restores them correctly.
    //
    func testFetchingData() {
        InstabugLogger.shared.deleteAllLogs()
        // Inserting 1000 message in the log
        for i in 0..<1000 {
            InstabugLogger.shared.log(Int64(i), message: "Message\(i)")
        }
        var result1 = true
        // Fetching all logs and check their contents
        let log = InstabugLogger.shared.fetchAllLogs()
        if let safeLog = log {
            for i in 0..<1000 {
                if(safeLog[i].level != i || safeLog[i].message != "Message\(i)") {
                    result1 = false
                    break
                }
            }
        }
        XCTAssertTrue(result1)
    }
    
    // Tests adding new element to the log and checks the maximum number of saved elements and maximum characters in the messsage.
    //
    func testAddingMessages() {
        // Test 1
        InstabugLogger.shared.deleteAllLogs()
        InstabugLogger.shared.log(1, message: "Message1")
        var log = InstabugLogger.shared.fetchAllLogs()
        var result1 = false
        if(log?.count == 1) {
            let message = log?[0].message ?? ""
            result1 = message == "Message1"
        }
        XCTAssertTrue(result1)
        
        // Test 2
        InstabugLogger.shared.deleteAllLogs()
        let invalidMessage = String(repeating: "A", count: 1001)
        InstabugLogger.shared.log(1, message: invalidMessage)
        log = InstabugLogger.shared.fetchAllLogs()
        let resultMessage = String(repeating: "A", count: 1000) + "..."
        let result2 = log?[0].message ?? "" == resultMessage
        XCTAssertTrue(result2)
        
        // Test 3
        InstabugLogger.shared.deleteAllLogs()
        // Inserting 1001 message in the log
        for i in 0..<1001 {
            InstabugLogger.shared.log(Int64(i), message: "Message\(i)")
        }
        var result3 = true
        // Fetching all logs and check their contents and count.
        log = InstabugLogger.shared.fetchAllLogs()
        if(log?.count == 1000) {
            if let safeLog = log {
                for i in 0..<1000 {
                    // The remainder elements should starts with level 1 and message "Message1" Scince the first added element was level 0 and Message0
                    if(safeLog[i].level != (i + 1) || safeLog[i].message != "Message\(i + 1)") {
                        result1 = false
                        break
                    }
                }
            }
        } else {
            result3 = false
        }
        XCTAssertTrue(result3)
    }
    
    // Tests the functionality of executing fetch then completion handler exexution
    func testFetchWithCompletionHandler() {
        var result = false
        InstabugLogger.shared.deleteAllLogs()
        InstabugLogger.shared.log(1, message: "Message1")
        var log = InstabugLogger.shared.fetchAllLogs { (log) in
            if(log[0].level == 1 && log[0].message == "Message1") {
                result = true;
            }
        }
        XCTAssertTrue(result)
    }
    
}
