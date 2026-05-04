//
//  NavLinkUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

@MainActor
final class NavLinkUITests: XCTestCase {

    // MARK: - Setup
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tests
    
    func test_fromSecondTab_tapNavLink1_verifyTitleAppears() {
        let navLinkTitle = app.staticTexts["Details for NavLink 1"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()
        app.buttons[AccessibilityID.Second.navLinkCell("NavLink 1")].tap()

        XCTAssertTrue(navLinkTitle.waitForExistence(timeout: 2))
    }

    func test_fromNavLink1_tapBack_verifySecondViewAppears() {
        let secondTitle = app.navigationBars["Second View"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()
        app.buttons[AccessibilityID.Second.navLinkCell("NavLink 1")].tap()
        
        /// tap the back button by its label. SwiftUI's back button label defaults to the previous screen's navigation title:
        app.navigationBars.buttons["Second View"].tap()
        
        XCTAssertTrue(secondTitle.waitForExistence(timeout: 2))
    }

    func test_fromSecondTab_tapNavLink2_verifyTitleAppears() {
        let navLinkTitle = app.staticTexts["Details for NavLink 2"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()
        app.buttons[AccessibilityID.Second.navLinkCell("NavLink 2")].tap()

        XCTAssertTrue(navLinkTitle.waitForExistence(timeout: 2))
    }

    func test_fromSecondTab_tapNavLink3_verifyTitleAppears() {
        let navLinkTitle = app.staticTexts["Details for NavLink 3"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()
        app.buttons[AccessibilityID.Second.navLinkCell("NavLink 3")].tap()

        XCTAssertTrue(navLinkTitle.waitForExistence(timeout: 2))
    }
}
