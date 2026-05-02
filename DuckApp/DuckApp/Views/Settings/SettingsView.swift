//
//  SettingsView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        List {            
            Section("Login Sheet") {
                Button("Show Login") {
                    router.showSheet(.login)
                }
            }
            
            Section("Some Cover") {
                Button("Show Cover") {
                    router.showCover(.appCover)
                }
            }
        }
        .navigationTitle("Settings View")
    }
}
