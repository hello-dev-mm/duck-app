//
//  NavLink.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import Foundation

struct NavLink: Hashable, Identifiable {
    let id: UUID
    let someString: String

    static let samples: [NavLink] = [
        NavLink(id: UUID(), someString: "NavLink 1"),
        NavLink(id: UUID(), someString: "NavLink 2"),
        NavLink(id: UUID(), someString: "NavLink 3")
    ]
}
