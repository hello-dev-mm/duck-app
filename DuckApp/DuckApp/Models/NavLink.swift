//
//  NavLink.swift
//  DuckApp
//
//  Created by Mariana Mendes on 02/05/2026.
//

import Foundation

struct NavLink: Hashable, Identifiable {
    let id = UUID()
    let someString: String

    /// static let samples property that holds the demo data in one place.
    static let samples: [NavLink] = [
        NavLink(someString: "NavLink 1"),
        NavLink(someString: "NavLink 2"),
        NavLink(someString: "NavLink 3")
    ]
}
