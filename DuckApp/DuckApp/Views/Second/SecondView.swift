//
//  SecondView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct SecondView: View {
    @Environment(Router.self) private var router
    /// Takes nav​Links as a parameter (var nav​Links: [​Nav​Link]) instead of hardcoding the array.
    var navLinks: [NavLink]
    
    var body: some View {
        List {
            Section("Switch Tabs") {
                Button("Go To Home Tab") {
                    router.switchToTab(.homeTab)
                }
                .accessibilityIdentifier(AccessibilityID.Second.switchToHomeTab)

                Button("Go To Settings Tab") {
                    router.switchToTab(.settingsTab)
                }
                .accessibilityIdentifier(AccessibilityID.Second.switchToSettingsTab)
            }

            Section("Push Detail View") {
                Button("Push Detail View C") {
                    router.navigate(to: .detail(item: "C"))
                }
                .accessibilityIdentifier(AccessibilityID.Second.pushDetailC)
            }

            Section("Deep Link") {
                Button("Jump to Settings > Detail X") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "X"))
                }
                .accessibilityIdentifier(AccessibilityID.Second.deepLinkSettingsX)
            }

            Section("Navigation Links") {
                ForEach(navLinks) { navLink in
                    NavigationLink(navLink.someString, value: navLink)
                        .accessibilityIdentifier(AccessibilityID.Second.navLinkCell(navLink.id))
                }
            }
        }
        .navigationTitle("Second View")
        .navigationDestination(for: NavLink.self) { navLink in
            NavLinkDetailsView(navLink: navLink)
        }
    }
}
