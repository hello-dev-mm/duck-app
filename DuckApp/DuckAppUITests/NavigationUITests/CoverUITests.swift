//
//  CoverUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

final class CoverUITests: XCTestCase {
    
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
    
    func test_fromSettings_tapShowcover_verifyAppCoverAppears() throws {
        let coverTextElement = app.staticTexts[AccessibilityID.Cover.text]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        
        XCTAssertTrue(coverTextElement.waitForExistence(timeout: 2))
    }
    
    func test_insideCover_tapGoDeeper_verifyDetailCoverAppears() throws {
        let detailCoverTitle = app.navigationBars["Detail Cover Detail"] // TODO: Accessibility ID, maybe another detail
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        app.buttons[AccessibilityID.Cover.goDeeper].tap()
        
        XCTAssertTrue(detailCoverTitle.waitForExistence(timeout: 2))
    }
    
    func test_insideCover_tapClose_verifyCoverDismissedandBackOnSettings() throws {
        let settingsTitle = app.navigationBars["Settings View"]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        app.buttons[AccessibilityID.Cover.close].firstMatch.tap()
        
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }
}
