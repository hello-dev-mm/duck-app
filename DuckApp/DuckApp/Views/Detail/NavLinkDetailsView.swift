//
//  NavLinkDetailsView.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import SwiftUI

struct NavLinkDetailsView: View {
    let navLink: NavLink
    
    var body: some View {
        Text("Details for \(navLink.someString)")
    }
}
