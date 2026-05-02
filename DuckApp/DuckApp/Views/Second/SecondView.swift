//
//  SecondView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

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
                Button("Go To Home Tab") {
                    router.switchToTab(.homeTab)
                }
                
                Button("Go To Settings Tab") {
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
            NavLinkDetailsView(navLink: navLink)
        }
    }
}
