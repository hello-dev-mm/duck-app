//
//  ViewFactory.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct ViewFactory {
    // MARK: - Build View
    /// By using buildView(for:), the views are entirely agnostic of one another. HomeView doesn't need to import or know about DetailView; it only knows about AppRoute. This makes testing and refactoring significantly easier.
    @ViewBuilder
    static func buildView(for route: AppRoute) -> some View {
        switch route {
        case .homeRoute: HomeView()
        case .secondRoute: SecondView()
        case .settingsRoute: SettingsView()
        case .detail(let item): DetailView(item: item)
        case .forgotPassword:
            Text("Reset Password Screen")
                .navigationTitle("Reset")
        }
    }

    // MARK: - Build Sheet
    @ViewBuilder
    static func buildSheet(for sheet: AppSheet) -> some View {
        switch sheet {
        case .login:
            LoginView()
        }
    }

    // MARK: - Build Cover
    // TODO: - Refactor content into a view
    @ViewBuilder
    static func buildCover(for cover: AppCover, router: Router) -> some View {
        @Bindable var router = router
        NavigationStack(path: $router.coverPath) {
            Group {
                switch cover {
                case .appCover:
                    VStack {
                        Text("App Cover Content")
                        Button("Go Deeper") { router.navigate(to: .detail(item: "Cover Detail")) }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { router.dismiss() }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                ViewFactory.buildView(for: route)
            }
        }
    }
}
