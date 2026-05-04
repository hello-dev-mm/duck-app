//
//  NavLinkTests.swift
//  DuckAppUnitTests
//
//  Created by Mariana Mendes on 04/05/2026.
//

import Testing
import Foundation
@testable import DuckApp

struct NavLinkTests {    
    // MARK: - Identifiable and Hashable: uniqueIds and equality
    @Test func twoNavLinks_withDifferentIDs_areNotEqual() {
        let firstID = UUID()
        let secondID = UUID()
        
        let firstNavLink = NavLink(id: firstID, someString: "someString")
        let secondNavLink = NavLink(id: secondID, someString: "someString")
        
        #expect(firstNavLink != secondNavLink)
        
    }
    
    @Test func twoNavLinks_withSameID_areEqual() {
        let id = UUID()
        
        let firstNavLink = NavLink(id: id, someString: "someString")
        let secondNavLink = NavLink(id: id, someString: "someString")
        
        #expect(firstNavLink == secondNavLink)
    }
    
    // MARK: - samples: static data
    @Test func samples_hasThreeItems() {
        #expect(NavLink.samples.count == 3)
    }
    
    @Test func samples_areStableAcrossAccesses() {
        let firstAccess = NavLink.samples.map { $0.id }
        let secondAccess = NavLink.samples.map { $0.id }

        #expect(firstAccess == secondAccess)
    }
    
    // MARK: - samples: unique IDs
    @Test func samples_haveUniqueIDs() {
        let samples = NavLink.samples
        let sampleIdsSet = Set(NavLink.samples.map { $0.id })
        
        #expect(samples.count == sampleIdsSet.count)
    }
}
