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
    var secondTabPath = NavigationPath()
    var settingsTabPath = NavigationPath()
    
    /// Navigation Path for the sheet
    var sheetPath = NavigationPath()
    
    /// Navigation Path for the full screen cover
    var coverPath = NavigationPath()
    
    /// Helper to get the path for the currently active tab
    private var currentPath: NavigationPath {
        get {
            /// Priority 1: If a cover is open, navigation happens there
            if presentedCover != nil { return coverPath }
            
            /// Priority 2: If a sheet is open, navigation happens there
            if presentedSheet != nil { return sheetPath }
            
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
                sheetPath = newValue
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
    /// SwiftUI doesn't switch tabs instantly. It schedules a UI update.
    /// If navigate runs before SwiftUI has finished processing the tab switch, the navigation path might not be wired up yet, and the push can get lost.
    func deepLink(to tab: AppTab, route: AppRoute) {
        selectedTab = tab

        /// Without Task both lines run in the same render cycle. SwiftUI hasn't processed the tab switch yet when navigate fires.
        Task { @MainActor in /// @​Main​Actor is Swift's way of saying "this code must run on the main thread."
            /// The 50ms sleep gives SwiftUI a full render cycle to process the tab switch before the route is pushed.
            /// It's short enough that the user won't notice any delay, but long enough to be reliable.
            try? await Task.sleep(for: .milliseconds(50))
            navigate(to: route)
        }
        
        /// Task = "schedule this for later" (not "run on another thread")
        /// @MainActor in = "and make sure 'later' still means the main thread"
        /// sleep = "wait long enough for SwiftUI to finish the tab switch"
    }
    
    /// Presents a sheet
    func showSheet(_ sheet: AppSheet) {
        presentedSheet = sheet
    }
    
    /// Presents a cover
    func showCover(_ cover: AppCover) {
        presentedCover = cover
    }
    
    /// Dismisses the topmost presented layer (cover first, then sheet).
    func dismiss() {
        if presentedCover != nil {
            dismissCover()
        } else if presentedSheet != nil {
            dismissSheet()
        }
    }

    func dismissSheet() {
        presentedSheet = nil
        sheetPath = NavigationPath()
    }

    func dismissCover() {
        presentedCover = nil
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
