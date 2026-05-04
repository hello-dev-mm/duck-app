//
//  PushPopUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

final class PushPopUITests: XCTestCase {

    // MARK: - Setup
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // TODO: - Question: What should we put here?
    }

    func testExample() throws {
       
    }
    
//    • Tap "Push Detail View A" on Home, verify "Detail A" appears
//    • From Detail A, tap push next, verify "Detail A2" appears
//    • Tap go back, verify you return to "Detail A"
//    • Tap pop to root, verify you return to "Home View"
//    • Tap go back on the first detail level, verify you return to "Home View"
}
