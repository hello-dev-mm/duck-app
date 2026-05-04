//
//  TabNavigationUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

final class TabUITests: XCTestCase {

    // MARK: - Setup
    /// Proxy for an application that may or may not be running.
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false /// stop immediately if something fails (don't tap buttons on a broken screen)
        app = XCUIApplication() /// app running in a simulator
        app.launch() /// starts the app fresh before every test
    }

    // MARK: - Tests

    @MainActor
    func testHomeTab_isVisibleOnLaunch() {
        let homeTitle = app.navigationBars["Home View"]
        
        /// UI transitions (tab switches, navigation pushes) aren't instant, they animate.
        /// If the assertion runs before the animation completes, the test fails intermittently.
        /// Every assertion after a navigation action should use wait​For​Existence.
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 2))
    }

    @MainActor
    func testTappingSecondTab_showsSecondView() {
        let secondTitle = app.navigationBars["Second View"]

        app.tabBars.buttons[AccessibilityID.Tab.second].tap()

        XCTAssertTrue(secondTitle.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testTappingSettingsTab_showsSettingsView() {
        let settingsTitle = app.navigationBars["Settings View"]
        
        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()

        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }

    @MainActor
    func testTabState_isPreservedWhenSwitching() {
        let detailTitleA = app.navigationBars["Detail A"]
        let settingsTitle = app.navigationBars["Settings View"]
        
        app.buttons[AccessibilityID.Home.pushDetailA].tap()
        XCTAssertTrue(detailTitleA.waitForExistence(timeout: 2))

        app.tabBars.buttons[AccessibilityID.Tab.settings].tap()
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))

        app.tabBars.buttons[AccessibilityID.Tab.home].tap()
        XCTAssertTrue(detailTitleA.waitForExistence(timeout: 2))
    }
}
