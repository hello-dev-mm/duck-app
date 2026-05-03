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
        TabView(selection: router.selectedTabBinding) {
            NavigationStack(path: router.homeTabPathBinding) {
                HomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.buildView(for: route)
                    }
            }
            .tag(AppTab.homeTab)
            .tabItem { Label("Home", systemImage: "house") }

            NavigationStack(path: router.secondTabPathBinding) {
                SecondView(navLinks: NavLink.samples)
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.buildView(for: route)
                    }
            }
            .tag(AppTab.secondTab)
            .tabItem { Label("Second", systemImage: "moon") }

            NavigationStack(path: router.settingsTabPathBinding) {
                SettingsView()
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.buildView(for: route)
                    }
            }
            .tag(AppTab.settingsTab)
            .tabItem { Label("Settings", systemImage: "gear") }
        }
        .environment(router)
        .sheet(item: router.presentedSheetBinding) { sheet in
            ViewFactory.buildSheet(for: sheet)
                .environment(router)
        }
        .fullScreenCover(item: router.presentedCoverBinding) { cover in
            ViewFactory.buildCover(for: cover)
                .environment(router)
        }
    }
}

#Preview {
    ContentView()
}
