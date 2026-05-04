//
//  DeepLinkUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

@MainActor
final class DeepLinkUITests: XCTestCase {

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
    
    func test_fromHomeTab_tapDeeplink_verifySettingsTabActive() {
        app.buttons[AccessibilityID.Home.deepLinkSettingsZ].tap()

        let settingsTab = app.tabBars.buttons[AccessibilityID.Tab.settings]
        
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 2))
        XCTAssertTrue(settingsTab.isSelected)
    }
    
    func test_fromHomeTab_deepLinkToSettingsDetailZ_verifyDetailZAppears() {
        let detailZTitle = app.navigationBars["Detail Z"]

        app.buttons[AccessibilityID.Home.deepLinkSettingsZ].tap()

        XCTAssertTrue(detailZTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromSecondTab_deepLinkToSettingsDetailX_verifyDetailXAppears() {
        let detailXTitle = app.navigationBars["Detail X"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()
        app.buttons[AccessibilityID.Second.deepLinkSettingsX].tap()

        XCTAssertTrue(detailXTitle.waitForExistence(timeout: 2))
    }
    
    func test_fromDetailView_tapDeeplink_verifyDeepLinkTitleAppears() {
        let detailVTitle = app.navigationBars["Detail V"]

        /// XCUI's tap() implicitly waits for the element to exist and be hittable before tapping.
        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        app.buttons[AccessibilityID.Detail.deepLinkSettingsV].tap()

        XCTAssertTrue(detailVTitle.waitForExistence(timeout: 2))
    }
}
