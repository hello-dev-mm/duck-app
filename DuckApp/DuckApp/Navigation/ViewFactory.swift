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
        case .secondRoute: SecondView(navLinks: NavLink.samples)
        case .settingsRoute: SettingsView()
        case .detail(let item): DetailView(item: item)
        case .sheetDetail:
            Text("Sheet Detail")
                .navigationTitle("Sheet Detail")
        }
    }

    // MARK: - Build Sheet
    @ViewBuilder
    static func buildSheet(for sheet: AppSheet) -> some View {
        switch sheet {
        case .appSheet:
            SheetView()
        }
    }

    // MARK: - Build Cover
    @ViewBuilder
    static func buildCover(for cover: AppCover) -> some View {
        switch cover {
        case .appCover:
            CoverView()
        }
    }
}
