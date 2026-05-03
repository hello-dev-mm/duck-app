//
//  AppNavigation.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

// MARK: - Tabs
/// AppTab is the physical structure
/// It tells the TabView which screen is currently active.
/// Its state is a single value (.homeTab, .secondTab, or .settingsTab). Without this, the app wouldn't know which tab to highlight in blue or which "root" view to show when we click the bottom bar.
enum AppTab {
    case homeTab, secondTab, settingsTab
}

// MARK: - Routes
/// AppRoute is the navigation history:
/// It acts as "data" that represents a destination. Its state is stored in a NavigationPath (a list). Allows passing that data around.
enum AppRoute: Hashable {
    case homeRoute, secondRoute, settingsRoute
    case detail(item: String)
    case sheetDetail
}

// MARK: - Sheets
enum AppSheet: Identifiable, Hashable {
    case appSheet
    
    /// Required for Identifiable
    var id: String {
        switch self {
        case .appSheet: return "App Sheet"
        }
    }
}

// MARK: - Covers
enum AppCover: Identifiable, Hashable {
    case appCover
    
    var id: String {
        switch self {
        case .appCover: return "App Cover"
        }
    }
}
