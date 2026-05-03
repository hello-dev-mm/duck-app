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
        @Bindable var router = router
        
        NavigationStack(path: $router.sheetPath) {
            VStack(spacing: 20) {
                Button("Do something") {
                    router.navigate(to: .sheetDetail)
                }
                Button("Done") { router.dismiss() }
            }
            .navigationTitle("Sheet View")
            .navigationDestination(for: AppRoute.self) { route in
                ViewFactory.buildView(for: route)
            }
        }
    }
}
