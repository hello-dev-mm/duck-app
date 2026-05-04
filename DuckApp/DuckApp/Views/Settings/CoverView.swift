//
//  CoverView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 03/05/2026.
//

import SwiftUI

struct CoverView: View {
    @Environment(Router.self) private var router

    var body: some View {
        NavigationStack(path: router.coverPathBinding) {
            VStack {
                Text("App Cover Content")
                    .accessibilityIdentifier(AccessibilityID.Cover.text)
                Button("Go Deeper") { router.navigate(to: .detail(item: "Cover Detail")) }
                    .accessibilityIdentifier(AccessibilityID.Cover.goDeeper)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { router.dismiss() }
                        .accessibilityIdentifier(AccessibilityID.Cover.close)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                ViewFactory.buildView(for: route)
            }
        }
    }
}
