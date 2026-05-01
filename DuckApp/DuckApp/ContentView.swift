//
//  ContentView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 01/05/2026.
//

import SwiftUI
import Observation


// MARK: - Tabs
/// AppTab is the physical structure
/// It tells the TabView which screen is currently active. Its state is a single value (.homeTab, .mainTab, or .settingsTab). Without this, the app wouldn't know which tab to highlight in blue or which "root" view to show when we click the bottom bar.
enum AppTab {
    case homeTab, firstTab, secondTab, settingsTab
}

// MARK: - Routes
/// AppRoute is the navigation history:
/// It acts as "data" that represents a destination. Its state is stored in a NavigationPath (a list). Allows passing that data around.
enum AppRoute: Hashable {
    case homeRoute, firstRoute, secondRoute, settingsRoute, detail(item: String)
}

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
    
    /// Navigation Paths for every tab: It allows each tab to maintain its own independent navigation stack. If a user drills deep into the homeTab and then switches to settingsTab, their position in the Home tab is preserved.
    var homeTabPath = NavigationPath()
    var firstTabPath = NavigationPath()
    var secondTabPath = NavigationPath()
    var settingsTabPath = NavigationPath()
    
    /// Helper to get the path for the currently active tab
    private var currentPath: NavigationPath {
        get {
            switch selectedTab {
            case .homeTab: return homeTabPath
            case .firstTab: return firstTabPath
            case .secondTab: return secondTabPath
            case .settingsTab: return settingsTabPath
            }
        }
        set {
            switch selectedTab {
            case .homeTab: homeTabPath = newValue
            case .firstTab: firstTabPath = newValue
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

// MARK: - ContentView
struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        /// The @Bindable property wrapper is specifically designed for the new Observation framework.
        /// When we define @State private var router = Router(), the view owns the router. You can call its functions (like router.navigate()) easily. The issue is that many SwiftUI components, like TabView and NavigationStack, require a Binding (a two-way connection). They don't just want to see the data; they need to write back to it automatically when the user interacts with the UI (like swiping between tabs).
        /// Standard @Observable classes do not automatically provide bindings to their properties. If we tried to write TabView(selection: $router.selectedTab) without the @Bindable line, Swift would throw an error saying it cannot find $router in scope. By adding @Bindable var router = router, we are creating a "binding-ready" version of the router. The binding $ prefix only becomes available through this wrapper.
        /// Why is it inside body? This is a common pattern when the source of truth is a @State variable or comes from the @Environment. We "wrap" it in @Bindable right before you use it in your UI layout so that the $ syntax works for all the child components.
        @Bindable var router = router
        
        /// When the user clicks, for example, the "Settings" icon at the bottom of the screen, the TabView uses the binding to reach into your Router and change selectedTab to .settingsTab.
        TabView(selection: $router.selectedTab) {
            // MARK: Home
            /// By passing a binding to the router's path, we are telling SwiftUI: "Keep this in sync with the homeTabPath array."
            /// If we manually append a route to homeTabPath in the code, the stack adds a new view. If the user taps the "Back" button, SwiftUI automatically removes that item from the homeTabPath array.
            NavigationStack(path: $router.homeTabPath) {
                HomeView()
                /// This tells the stack, "Listen for any data of the type AppRoute that gets pushed onto the path."
                    .navigationDestination(for: AppRoute.self) { route in
                        buildView(for: route)
                    }
            }
            /// Identify the stack within the tabView
            .tag(AppTab.homeTab)
            .tabItem { Label("Home", systemImage: "house") }
            
            // MARK: First
            NavigationStack(path: $router.firstTabPath) {
                FirstView()
                    .navigationDestination(for: AppRoute.self) { route in
                        buildView(for: route)
                    }
            }
            .tag(AppTab.firstTab)
            .tabItem { Label("First", systemImage: "sun.max") }
            
            // MARK: Second
            NavigationStack(path: $router.secondTabPath) {
                SecondView()
                    .navigationDestination(for: AppRoute.self) { route in
                        buildView(for: route)
                    }
            }
            .tag(AppTab.secondTab)
            .tabItem { Label("Second", systemImage: "moon") }
            
            // MARK: Settings
            NavigationStack(path: $router.settingsTabPath) {
                SettingsView()
                    .navigationDestination(for: AppRoute.self) { route in
                        buildView(for: route)
                    }
            }
            .tag(AppTab.settingsTab)
            .tabItem { Label("Settings", systemImage: "gear") }
        }
        .environment(router)
    }
    
    
    /// By using buildView(for:), the views are entirely agnostic of one another. HomeView doesn't need to import or know about DetailView; it only knows about AppRoute. This makes testing and refactoring significantly easier.
    @ViewBuilder
    func buildView(for route: AppRoute) -> some View {
        switch route {
        case .homeRoute: HomeView()
        case .firstRoute: FirstView()
        case .secondRoute: SecondView()
        case .settingsRoute: SettingsView()
        case .detail(let item): DetailView(item: item)
        }
    }
}

// MARK: - Models
struct NavLink: Hashable, Identifiable {
    let id = UUID()
    let name: String
}

// MARK: - Views
struct HomeView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To First View") {
                    router.switchToTab(.firstTab)
                }
                
                Button("Go To Second View") {
                    router.switchToTab(.secondTab)
                }
                
                Button("Go To Settings View") {
                    router.switchToTab(.settingsTab)
                }
            }
            
            Section("Push Detail View") {
                Button("Push Detail View A") {
                    router.navigate(to: .detail(item: "A"))
                }
            }
            
            Section("Deep Link") {
                Button("Jump to Settings > Detail Z") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "Z"))
                }
            }
        }
        .navigationTitle("Home View")
    }
}

struct FirstView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To Home View") {
                    router.switchToTab(.homeTab)
                }
                
                Button("Go To Second View") {
                    router.switchToTab(.secondTab)
                }
                
                Button("Go To Settings View") {
                    router.switchToTab(.settingsTab)
                }
            }
            
            Section("Push Detail View") {
                Button("Push Detail View B") {
                    router.navigate(to: .detail(item: "B"))
                }
            }
            
            Section("Deep Link") {
                Button("Jump to Settings > Detail Y") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "Y"))
                }
            }
        }
        .navigationTitle("First View")
    }
}

struct SecondView: View {
    @Environment(Router.self) private var router
    let navLinks: [NavLink] = [
        NavLink(name: "NavLink 1"),
        NavLink(name: "NavLink 2"),
        NavLink(name: "NavLink 3")
    ]
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To Home View") {
                    router.switchToTab(.homeTab)
                }
                
                Button("Go To First View") {
                    router.switchToTab(.firstTab)
                }
                
                Button("Go To Settings View") {
                    router.switchToTab(.settingsTab)
                }
            }
                
            Section("Push Detail View") {
                Button("Push Detail View C") {
                    router.navigate(to: .detail(item: "C"))
                }
            }
            
            Section("Deep Link") {
                Button("Jump to Settings > Detail X") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "X"))
                }
            }
            
            Section("Navigation Links") {
                ForEach(navLinks) { navLink in
                    NavigationLink(navLink.name, value: navLink)
                }
            }
        }
        .navigationTitle("Second View")
        .navigationDestination(for: NavLink.self) { navLink in
            NavLinkDetails(navLink: navLink)
        }
    }
}

struct SettingsView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To Home View") {
                    router.switchToTab(.homeTab)
                }
                
                Button("Go To First View") {
                    router.switchToTab(.firstTab)
                }
                
                Button("Go To Second View") {
                    router.switchToTab(.secondTab)
                }
            }
            
            Section("Push Detail View") {
                Button("Push Detail View D") {
                    router.navigate(to: .detail(item: "D"))
                }
            }
            
            Section("Deep Link") {
                Button("Jump to Home > Detail W") {
                    router.deepLink(to: .homeTab, route: .detail(item: "W"))
                }
            }
        }
        .navigationTitle("Settings View")
    }
}

struct DetailView: View {
    let item: String
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            List {
                Section("Switch Tabs") {
                    if router.selectedTab != .homeTab {
                        Button("Go To Home View") { router.switchToTab(.homeTab) }
                    }
                    
                    if router.selectedTab != .firstTab {
                        Button("Go To First View") { router.switchToTab(.firstTab) }
                    }
                    
                    if router.selectedTab != .secondTab {
                        Button("Go To Second View") { router.switchToTab(.secondTab) }
                    }
                    
                    if router.selectedTab != .settingsTab {
                        Button("Go To Settings View") { router.switchToTab(.settingsTab) }
                    }
                }
                
                /// Identifies the root letter (e.g., "A") and calculates the next name based on stack depth
                let rootLetter = String(item.prefix(1))
                let nextNumber = router.currentPathCount + 1
                let nextItemName = "\(rootLetter)\(nextNumber)"
                
                Section("Push Detail View") {
                    Button("Push Detail View \(nextItemName)") {
                        router.navigate(to: .detail(item: nextItemName))
                    }
                }
                
                Section("Deep Link") {
                    Button("Jump to Settings > Detail V") {
                        router.deepLink(to: .settingsTab, route: .detail(item: "V"))
                    }
                }
                
                Section("Pop Controls") {
                    Button("Go Back One Level") {
                        router.goBack()
                    }
                    
                    Button("Back to Root") {
                        router.popToRoot()
                    }
                    .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Detail \(item)")
    }
}

struct NavLinkDetails: View {
    let navLink: NavLink
    
    var body: some View {
        Text("Details for \(navLink.name)")
    }
}

#Preview {
    ContentView()
}
