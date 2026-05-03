//
//  RouterTests.swift
//  DuckAppUnitTests
//
//  Created by Mariana Mendes on 03/05/2026.
//

import Testing
import SwiftUI
@testable import DuckApp

// MARK: - Tab Switching
struct RouterTabTests {
    @Test func defaultTab_isHomeTab() {
        let router = Router()

        #expect(router.selectedTab == .homeTab)
    }
    
    @Test func switchToTab_changesSelectedTab() {
        let router = Router()

        router.switchToTab(.settingsTab)

        #expect(router.selectedTab == .settingsTab)
    }
}

// MARK: - Navigation
struct RouterNavigationTests {
    @Test func navigate_appendsToCurrentTabPath() {
        let router = Router()

        router.navigate(to: .detail(item: "A"))

        #expect(router.homeTabPath.count == 1)
    }

    @Test func navigate_onSecondTab_appendsToSecondTabPath() {
        let router = Router()
        router.switchToTab(.secondTab)

        router.navigate(to: .detail(item: "B"))

        #expect(router.secondTabPath.count == 1)
        #expect(router.homeTabPath.count == 0)
    }

    @Test func navigate_onSettingsTab_appendsToSettingsTabPath() {
        let router = Router()
        router.switchToTab(.settingsTab)

        router.navigate(to: .detail(item: "C"))

        #expect(router.settingsTabPath.count == 1)
        #expect(router.homeTabPath.count == 0)
    }

    @Test func currentPathCount_reflectsNavigationDepth() {
        let router = Router()

        router.navigate(to: .detail(item: "A"))
        router.navigate(to: .detail(item: "B"))

        #expect(router.currentPathCount == 2)
    }
}

// MARK: - Go Back
struct RouterGoBackTests {
    @Test func goBack_removesLastRoute() {
        let router = Router()
        router.navigate(to: .detail(item: "A"))
        router.navigate(to: .detail(item: "B"))

        router.goBack()

        #expect(router.homeTabPath.count == 1)
    }

    @Test func goBack_emptyPath_doesNotCrash() {
        let router = Router()

        router.goBack()

        #expect(router.homeTabPath.count == 0)
    }
}

// MARK: - Pop to Root
struct RouterPopToRootTests {
    @Test func popToRoot_clearsEntirePath() {
        let router = Router()
        router.navigate(to: .detail(item: "A"))
        router.navigate(to: .detail(item: "B"))
        router.navigate(to: .detail(item: "C"))

        router.popToRoot()

        #expect(router.homeTabPath.count == 0)
    }

    @Test func popToRoot_onCorrectTab() {
        let router = Router()
        router.switchToTab(.secondTab)
        router.navigate(to: .detail(item: "A"))

        router.popToRoot()

        #expect(router.secondTabPath.count == 0)
    }
}

// MARK: - Sheet Presentation
struct RouterSheetTests {
    @Test func showSheet_presentsSheet() {
        let router = Router()

        router.showSheet(.appSheet)

        #expect(router.presentedSheet == .appSheet)
    }

    @Test func dismissSheet_clearsSheet() {
        let router = Router()
        router.showSheet(.appSheet)

        router.dismissSheet()

        #expect(router.presentedSheet == nil)
    }

    @Test func dismissSheet_resetsSheetPath() {
        let router = Router()
        router.showSheet(.appSheet)
        router.navigate(to: .sheetDetail)

        router.dismissSheet()

        #expect(router.sheetPath.count == 0)
    }

    @Test func navigate_withSheetPresented_appendsToSheetPath() {
        let router = Router()
        router.showSheet(.appSheet)

        router.navigate(to: .sheetDetail)

        #expect(router.sheetPath.count == 1)
        #expect(router.homeTabPath.count == 0)
    }
}

// MARK: - Cover Presentation
struct RouterCoverTests {
    @Test func showCover_presentsCover() {
        let router = Router()

        router.showCover(.appCover)

        #expect(router.presentedCover == .appCover)
    }

    @Test func dismissCover_clearsCover() {
        let router = Router()
        router.showCover(.appCover)

        router.dismissCover()

        #expect(router.presentedCover == nil)
    }

    @Test func dismissCover_resetsCoverPath() {
        let router = Router()
        router.showCover(.appCover)
        router.navigate(to: .detail(item: "X"))

        router.dismissCover()

        #expect(router.coverPath.count == 0)
    }

    @Test func navigate_withCoverPresented_appendsToCoverPath() {
        let router = Router()
        router.showCover(.appCover)

        router.navigate(to: .detail(item: "X"))

        #expect(router.coverPath.count == 1)
        #expect(router.homeTabPath.count == 0)
    }
}

// MARK: - Dismiss Priority
struct RouterDismissTests {
    @Test func dismiss_withOnlySheet_dismissesSheet() {
        let router = Router()
        router.showSheet(.appSheet)

        router.dismiss()

        #expect(router.presentedSheet == nil)
    }

    @Test func dismiss_withOnlyCover_dismissesCover() {
        let router = Router()
        router.showCover(.appCover)

        router.dismiss()

        #expect(router.presentedCover == nil)
    }

    @Test func dismiss_withBoth_dismissesCoverFirst() {
        let router = Router()
        router.showSheet(.appSheet)
        router.showCover(.appCover)

        router.dismiss()

        #expect(router.presentedCover == nil)
        #expect(router.presentedSheet == .appSheet)
    }

    @Test func dismiss_withBoth_calledTwice_dismissesBoth() {
        let router = Router()
        router.showSheet(.appSheet)
        router.showCover(.appCover)

        router.dismiss()
        router.dismiss()

        #expect(router.presentedCover == nil)
        #expect(router.presentedSheet == nil)
    }

    @Test func dismiss_nothingPresented_doesNotCrash() {
        let router = Router()

        router.dismiss()

        #expect(router.presentedSheet == nil)
        #expect(router.presentedCover == nil)
    }
}

// MARK: - Navigation Priority (Cover > Sheet > Tab)
struct RouterNavigationPriorityTests {
    @Test func navigate_coverTakesPriorityOverSheet() {
        let router = Router()
        router.showSheet(.appSheet)
        router.showCover(.appCover)

        router.navigate(to: .detail(item: "X"))

        #expect(router.coverPath.count == 1)
        #expect(router.sheetPath.count == 0)
    }

    @Test func navigate_sheetTakesPriorityOverTab() {
        let router = Router()
        router.showSheet(.appSheet)

        router.navigate(to: .sheetDetail)

        #expect(router.sheetPath.count == 1)
        #expect(router.homeTabPath.count == 0)
    }

    @Test func goBack_insideCover_removesFromCoverPath() {
        let router = Router()
        router.showCover(.appCover)
        router.navigate(to: .detail(item: "X"))

        router.goBack()

        #expect(router.coverPath.count == 0)
    }

    @Test func popToRoot_insideSheet_clearsSheetPath() {
        let router = Router()
        router.showSheet(.appSheet)
        router.navigate(to: .sheetDetail)

        router.popToRoot()

        #expect(router.sheetPath.count == 0)
    }
}

// MARK: - Deep Link
struct RouterDeepLinkTests {
    @Test func deepLink_switchesTab() {
        let router = Router()

        router.deepLink(to: .settingsTab, route: .detail(item: "Z"))

        #expect(router.selectedTab == .settingsTab)
    }

    @Test @MainActor func deepLink_navigatesAfterDelay() async throws {
        let router = Router()

        router.deepLink(to: .settingsTab, route: .detail(item: "Z"))

        try await Task.sleep(for: .milliseconds(100))
        #expect(router.settingsTabPath.count == 1)
    }
}

// MARK: - Tab Independence
struct RouterTabIndependenceTests {
    @Test func tabPaths_areIndependent() {
        let router = Router()

        router.switchToTab(.homeTab)
        router.navigate(to: .detail(item: "A"))

        router.switchToTab(.secondTab)
        router.navigate(to: .detail(item: "B"))

        router.switchToTab(.settingsTab)
        router.navigate(to: .detail(item: "C"))

        #expect(router.homeTabPath.count == 1)
        #expect(router.secondTabPath.count == 1)
        #expect(router.settingsTabPath.count == 1)
    }

    @Test func popToRoot_onlyAffectsCurrentTab() {
        let router = Router()

        router.switchToTab(.homeTab)
        router.navigate(to: .detail(item: "A"))

        router.switchToTab(.secondTab)
        router.navigate(to: .detail(item: "B"))

        router.popToRoot()

        #expect(router.secondTabPath.count == 0)
        #expect(router.homeTabPath.count == 1)
    }
}
