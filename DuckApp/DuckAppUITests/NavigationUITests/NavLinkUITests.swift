//
//  NavLinkUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

final class NavLinkUITests: XCTestCase {

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
    
//    • On Second tab, tap "NavLink 1", verify "Details for NavLink 1" appears
//    • Tap back, verify you return to "Second View"
//    • Tap "NavLink 2", verify "Details for NavLink 2" appears
}
