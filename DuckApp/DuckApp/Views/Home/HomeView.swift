//
//  HomeView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To Second Tab") {
                    router.switchToTab(.secondTab)
                }
                .accessibilityIdentifier(AccessibilityID.Home.switchToSecondTab)

                Button("Go To Settings Tab") {
                    router.switchToTab(.settingsTab)
                }
                .accessibilityIdentifier(AccessibilityID.Home.switchToSettingsTab)
            }

            Section("Push Detail View") {
                Button("Push Detail View A") {
                    router.navigate(to: .detail(item: "A"))
                }
                .accessibilityIdentifier(AccessibilityID.Home.pushDetailA)
            }

            Section("Deep Link") {
                Button("Jump to Settings > Detail Z") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "Z"))
                }
                .accessibilityIdentifier(AccessibilityID.Home.deepLinkSettingsZ)
            }
        }
        .navigationTitle("Home View")
    }
}
