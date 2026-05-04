//
//  PushPopUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

@MainActor
final class PushPopUITests: XCTestCase {

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
    
    func test_onHome_pushDetailView_verifyDetailAppears() {
        let detailTitle = app.navigationBars["Detail A"]

        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromDetailView_tapPopToRoot_verifyHomeAppears() {
        let homeTitle = app.navigationBars["Home View"]

        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        app.buttons[AccessibilityID.Detail.popToRoot].tap()
        
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromDetailView_pushSubDetailView_verifySubDetailAppears() {
        let subDetailTitle = app.navigationBars["Detail A2"]

        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        app.buttons[AccessibilityID.Detail.pushNext].tap()
        
        XCTAssertTrue(subDetailTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromSubDetailView_tapGoBack_verifyDetailAppears() {
        let detailTitle = app.navigationBars["Detail A"]

        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        app.buttons[AccessibilityID.Detail.pushNext].tap()
        app.buttons[AccessibilityID.Detail.goBack].tap()
        
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromSubDetailView_tapPopToRoot_verifyHomeAppears() {
        let homeTitle = app.navigationBars["Home View"]

        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        app.buttons[AccessibilityID.Detail.pushNext].tap()
        app.buttons[AccessibilityID.Detail.popToRoot].tap()
        
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 2))
    }
}
