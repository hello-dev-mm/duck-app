//
//  SheetUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

@MainActor
final class SheetUITests: XCTestCase {

    // MARK: - Setup
    
    /// Proxy for an application that may or may not be running.
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false /// stop immediately if something fails (don't tap buttons on a broken screen)
        app = XCUIApplication() /// app running in a simulator
        app.launch() /// starts the app fresh before every test
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Tests
    
    func test_fromSettings_tapShowSheet_verifySheetAppears() {
        let sheetTitle = app.navigationBars["Sheet View"]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showSheet].tap()
        
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 2))
    }
    
    func test_insideSheet_tapDoSomething_verifySheetDetailAppears() {
        let sheetDetailTitle = app.navigationBars["Sheet Detail"]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showSheet].tap()
        app.buttons[AccessibilityID.Sheet.doSomething].tap()
        
        XCTAssertTrue(sheetDetailTitle.waitForExistence(timeout: 2))
    }
    
    func test_insideSheet_tapDone_verifySheetIsDismissed_andBackOnSettings() {
        let settingsTitle = app.navigationBars["Settings View"]

        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showSheet].tap()
        app.buttons[AccessibilityID.Sheet.done].tap()
        
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }
}
