//
//  SheetView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct SheetView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        NavigationStack(path: router.sheetPathBinding) {
            VStack(spacing: 20) {
                Button("Do something") {
                    router.navigate(to: .sheetDetail)
                }
                .accessibilityIdentifier(AccessibilityID.Sheet.doSomething)

                Button("Done") { router.dismiss() }
                    .accessibilityIdentifier(AccessibilityID.Sheet.done)
            }
            .navigationTitle("Sheet View")
            .navigationDestination(for: AppRoute.self) { route in
                ViewFactory.buildView(for: route)
            }
        }
    }
}
