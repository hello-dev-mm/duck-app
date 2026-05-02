//
//  ContentView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 01/05/2026.
//

import SwiftUI

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
                        ViewFactory.buildView(for: route)
                    }
            }
            /// Identify the stack within the tabView
            .tag(AppTab.homeTab)
            .tabItem { Label("Home", systemImage: "house") }
            
            // MARK: Second
            NavigationStack(path: $router.secondTabPath) {
                SecondView()
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.buildView(for: route)
                    }
            }
            .tag(AppTab.secondTab)
            .tabItem { Label("Second", systemImage: "moon") }
            
            // MARK: Settings
            NavigationStack(path: $router.settingsTabPath) {
                SettingsView()
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.buildView(for: route)
                    }
            }
            .tag(AppTab.settingsTab)
            .tabItem { Label("Settings", systemImage: "gear") }
        }
        .environment(router)
        .sheet(item: $router.presentedSheet) { sheet in
            ViewFactory.buildSheet(for: sheet)
                .environment(router)
        }
        .fullScreenCover(item: $router.presentedCover) { cover in
            ViewFactory.buildCover(for: cover, router: router)
                .environment(router)
        }
    }
}

#Preview {
    ContentView()
}
