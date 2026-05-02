//
//  Router.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

// MARK: - Router
/// With this setup, views don't need to know about each other. They only need to know how to talk to the Router.
/// The @Observable attribute makes this class a "source of truth" that SwiftUI views can watch. When any property inside this class changes (like selectedTab or a NavigationPath), any view observing this router will automatically re-render to reflect the change.
/// In SwiftUI’s modern Observation framework, views observe the Router through the Environment. This happens in a two-step process:
/// Step A: Injection (The Parent): In ContentView, we use the .environment(router) modifier. This places the specific instance of the Router into a "storage bucket" that is accessible to every single view inside the hierarchy of ContentView.
/// Step B: Extraction (The Child): Inside any child view (like HomeView or DetailView), we use the @Environment property wrapper.

@Observable
class Router {
    /// Tracks which tab the user is currently looking at.
    var selectedTab: AppTab = .homeTab
    /// Tracks which sheet is presented.
    var presentedSheet: AppSheet?
    /// Tracks which cover is presented.
    var presentedCover: AppCover?
    
    /// Navigation Paths for every tab: It allows each tab to maintain its own independent navigation stack. If a user drills deep into the homeTab and then switches to settingsTab, their position in the Home tab is preserved.
    var homeTabPath = NavigationPath()
    var firstTabPath = NavigationPath()
    var secondTabPath = NavigationPath()
    var settingsTabPath = NavigationPath()
    
    /// Navigation Path for the sheet
    var loginPath = NavigationPath()
    
    /// Navigation Path for the full screen cover
    var coverPath = NavigationPath()
    
    /// Helper to get the path for the currently active tab
    private var currentPath: NavigationPath {
        get {
            /// Priority 1: If a cover is open, navigation happens there
            if presentedCover != nil { return coverPath }
            
            /// Priority 2: If a sheet is open, navigation happens there
            if presentedSheet != nil { return loginPath }
            
            /// Priority 3: Standard Tabs
            switch selectedTab {
            case .homeTab: return homeTabPath
            case .secondTab: return secondTabPath
            case .settingsTab: return settingsTabPath
            }
        }
        set {
            if presentedCover != nil {
                coverPath = newValue
                return
            }
            
            if presentedSheet != nil {
                loginPath = newValue
                return
            }
            
            switch selectedTab {
            case .homeTab: homeTabPath = newValue
            case .secondTab: secondTabPath = newValue
            case .settingsTab: settingsTabPath = newValue
            }
        }
    }
    
    /// Helper to get the depth of stack path. Also useful for UI logic. For example, we might want to hide the custom tab bar if currentPathCount > 0 (meaning a detail view is covered).
    var currentPathCount: Int {
        currentPath.count
    }
    
    /// Programmatically changes the active tab (useful for "Deep Linking" or clicking a button that sends a user to a different section).
    func switchToTab(_ tab: AppTab) {
        self.selectedTab = tab
    }
    
    /// Appends a new route to the stack of the currently active tab.
    func navigate(to route: AppRoute) {
        currentPath.append(route)
    }
    
    /// Switches to a specific tab and then pushes a new route onto that tab's stack.
    func deepLink(to tab: AppTab, route: AppRoute) {
        selectedTab = tab
        
        /// Use Task @MainActor to ensure the UI has processed the tab switch before we try to append to the new tab's path.
        Task { @MainActor in
            /// Wait for a tiny fraction of a second (optional but smoother)
            navigate(to: route)
        }
    }
    
    /// Presents a sheet
    func showSheet(_ sheet: AppSheet) {
        presentedSheet = sheet
    }
    
    /// Presents a cover
    func showCover(_ cover: AppCover) {
        presentedCover = cover
    }
    
    /// Dismisses a sheet or cover
    /// In a robust Router, dismiss() acts as a state reset. Because SwiftUI sheets and covers are driven by item identity (presentedSheet and presentedCover), setting them to nil tells SwiftUI to remove them from the screen.
    func dismiss() {
        presentedSheet = nil
        presentedCover = nil
        loginPath = NavigationPath()
        coverPath = NavigationPath()
    }
    
    /// Removes the top-most view from the current stack.
    func goBack() {
        if !currentPath.isEmpty {
            currentPath.removeLast()
        }
    }
    
    /// Resets the path.  By assigning NavigationPath(), we are clearing the stack and returning the user to the very first view of that tab.
    func popToRoot() {
        currentPath = NavigationPath()
    }
}
