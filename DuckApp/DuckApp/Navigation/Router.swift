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
    /// All state properties are private(set) -- views can read them but can't write to them directly
    private(set) var selectedTab: AppTab = .homeTab
    private(set) var presentedSheet: AppSheet?
    private(set) var presentedCover: AppCover?

    private(set) var homeTabPath = NavigationPath()
    private(set) var secondTabPath = NavigationPath()
    private(set) var settingsTabPath = NavigationPath()
    private(set) var sheetPath = NavigationPath()
    private(set) var coverPath = NavigationPath()

    var deepLinkDelay: Duration = .milliseconds(50)

    // MARK: - Bindings for SwiftUI
    /// Each property has a matching Binding computed property that SwiftUI uses for two-way communication
    /// The bindings work because they're defined inside the Router class, so they have access to the private setters
    
    /// This is a computed property so it doesn't store anything.
    /// It creates a new Binding​<​App​Tab> every time it's accessed.
    /// Binding​<​App​Tab> is a SwiftUI type that provides two-way access to an App​Tab value.
    var selectedTabBinding: Binding<AppTab> {
        /// Creates a Binding by providing two closures: one for reading, one for writing.
        Binding(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )
    }
    
    /// 1. User taps "Settings" tab
    /// 2. Tab​View calls the binding's set closure with .settings​Tab
    /// 3. The closure sets self​.selected​Tab = .settings​Tab
    /// 4. @​Observable notices the change
    /// 5. SwiftUI re-renders the views

    var presentedSheetBinding: Binding<AppSheet?> {
        Binding(get: { self.presentedSheet }, set: { self.presentedSheet = $0 })
    }

    var presentedCoverBinding: Binding<AppCover?> {
        Binding(get: { self.presentedCover }, set: { self.presentedCover = $0 })
    }

    var homeTabPathBinding: Binding<NavigationPath> {
        Binding(get: { self.homeTabPath }, set: { self.homeTabPath = $0 })
    }

    var secondTabPathBinding: Binding<NavigationPath> {
        Binding(get: { self.secondTabPath }, set: { self.secondTabPath = $0 })
    }

    var settingsTabPathBinding: Binding<NavigationPath> {
        Binding(get: { self.settingsTabPath }, set: { self.settingsTabPath = $0 })
    }

    var sheetPathBinding: Binding<NavigationPath> {
        Binding(get: { self.sheetPath }, set: { self.sheetPath = $0 })
    }

    var coverPathBinding: Binding<NavigationPath> {
        Binding(get: { self.coverPath }, set: { self.coverPath = $0 })
    }
    
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
            try? await Task.sleep(for: deepLinkDelay)
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
