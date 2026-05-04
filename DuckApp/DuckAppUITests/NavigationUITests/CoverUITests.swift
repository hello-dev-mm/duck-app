//
//  CoverUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

@MainActor
final class CoverUITests: XCTestCase {
    
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
    
    func test_fromSettings_tapShowCover_verifyAppCoverAppears() {
        let coverTextElement = app.staticTexts[AccessibilityID.Cover.text]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        
        XCTAssertTrue(coverTextElement.waitForExistence(timeout: 2))
    }
    
    func test_insideCover_tapGoDeeper_verifyDetailCoverAppears() {
        let detailCoverTitle = app.otherElements[AccessibilityID.Cover.detailTitle]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        app.buttons[AccessibilityID.Cover.goDeeper].tap()
        
        XCTAssertTrue(detailCoverTitle.waitForExistence(timeout: 2))
    }
    
    func test_insideCoverDetail_tapBack_verifyCoverRootAppears() {
        let coverText = app.staticTexts[AccessibilityID.Cover.text]

        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        app.buttons[AccessibilityID.Cover.goDeeper].tap()
        app.navigationBars.buttons["Back"].tap()

        XCTAssertTrue(coverText.waitForExistence(timeout: 2))
    }

    func test_insideCover_tapClose_verifyCoverDismissedAndBackOnSettings() {
        let settingsTitle = app.navigationBars["Settings View"]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        app.buttons[AccessibilityID.Settings.showCover].tap()
        app.buttons[AccessibilityID.Cover.close].firstMatch.tap()
        
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }
}
