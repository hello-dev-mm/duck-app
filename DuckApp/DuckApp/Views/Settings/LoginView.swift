//
//  LoginView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.loginPath) {
            VStack(spacing: 20) {
                Button("Forgot Password?") {
                    router.navigate(to: .forgotPassword)
                }
                Button("Done") { router.dismiss() }
            }
            .navigationTitle("Login")
            .navigationDestination(for: AppRoute.self) { route in
                ViewFactory.buildView(for: route)
            }
        }
    }
}
