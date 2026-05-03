//
//  DetailView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct DetailView: View {
    let item: String
    @Environment(Router.self) private var router
    
    var body: some View {
        List {
            /// Identifies the root letter (e.g., "A") and calculates the next name based on stack depth
            let rootLetter = String(item.prefix(1))
            let nextNumber = router.currentPathCount + 1
            let nextItemName = "\(rootLetter)\(nextNumber)"
            
            Section("Push Detail View") {
                Button("Push Detail View \(nextItemName)") {
                    router.navigate(to: .detail(item: nextItemName))
                }
            }
            
            Section("Deep Link") {
                Button("Jump to Settings > Detail V") {
                    router.deepLink(to: .settingsTab, route: .detail(item: "V"))
                }
            }
            
            Section("Pop Controls") {
                Button("Go Back One Level") {
                    router.goBack()
                }
                
                Button("Back to Root") {
                    router.popToRoot()
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Detail \(item)")
    }
}
