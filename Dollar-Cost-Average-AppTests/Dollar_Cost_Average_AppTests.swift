//
//  Dollar_Cost_Average_AppTests.swift
//  Dollar-Cost-Average-AppTests
//
//  Created by Ben Garrison on 1/10/22.
//

import XCTest
@testable import Dollar_Cost_Average_App

class Dollar_Cost_Average_AppTests: XCTestCase {

    var sut: DCAService! // "system under test"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
