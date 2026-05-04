//
//  AccessibilityID.swift
//  DuckApp
//
//  Created by Mariana Mendes on 04/05/2026.
//

import Foundation

enum AccessibilityID {

    enum Tab {
        /// .accessibility​Identifier on a Navigation​Stack doesn't propagate to the tab bar button. SwiftUI names tab bar buttons after their Label text.
        static let home = "Home"
        static let second = "Second"
        static let settings = "Settings"
    }

    enum Home {
        static let switchToSecondTab = "home.switchToSecondTab"
        static let switchToSettingsTab = "home.switchToSettingsTab"
        static let pushDetailA = "home.pushDetailA"
        static let deepLinkSettingsZ = "home.deepLinkSettingsZ"
    }

    enum Second {
        static let switchToHomeTab = "second.switchToHomeTab"
        static let switchToSettingsTab = "second.switchToSettingsTab"
        static let pushDetailC = "second.pushDetailC"
        static let deepLinkSettingsX = "second.deepLinkSettingsX"
        static func navLinkCell(_ name: String) -> String { "second.navLink.\(name)" }
    }

    enum Settings {
        static let showSheet = "settings.showSheet"
        static let showCover = "settings.showCover"
    }
    
    enum Detail {
        static let pushNext = "detail.pushNext"
        static let deepLinkSettingsV = "detail.deepLinkSettingsV"
        static let goBack = "detail.goBack"
        static let popToRoot = "detail.popToRoot"
    }

    enum Sheet {
        static let doSomething = "sheet.doSomething"
        static let done = "sheet.done"
    }

    enum Cover {
        static let text = "cover.text"
        static let goDeeper = "cover.goDeeper"
        static let close = "cover.close"
        static let detailTitle = "cover.detailTitle"
    }
}
