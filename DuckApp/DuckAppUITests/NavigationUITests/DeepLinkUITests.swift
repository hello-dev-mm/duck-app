//
//  DeepLinkUITests.swift
//  DuckAppUITests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import XCTest

final class DeepLinkUITests: XCTestCase {

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
    
//    • From Home, tap "Jump to Settings > Detail Z", verify Settings tab is active and "Detail Z" appears
//    • From Second tab, tap "Jump to Settings > Detail X", verify "Detail X" appears
//    • From a Detail view, tap "Jump to Settings > Detail V", verify "Detail V" appears
}
