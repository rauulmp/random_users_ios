//
//  BlacklistRepositoryTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 20/4/26.
//

import Testing
import Foundation
@testable import RandomUsers

@Suite("Blacklist Repository Tests")
@MainActor
struct BlacklistRepositoryTests {
    
    let suiteName = "TestDefaults"
    var storage: UserDefaults { UserDefaults(suiteName: suiteName)! }
    var sut: BlacklistRepositoryImpl { BlacklistRepositoryImpl(storage: storage) }

    init() {
        storage.removePersistentDomain(forName: suiteName)
    }

    @Test("Repository saves and loads correctly")
    func testSaveAndLoad() {
        // Given
        let user = User.mock(id: "1")
        
        // When
        sut.add(user)
        let loaded = sut.load()
        
        // Then
        #expect(loaded.count == 1)
        #expect(loaded.first?.id == "1")
    }

    @Test("Repository removes user correctly")
    func testRemove() {
        // Given
        let user = User.mock(id: "1")
        sut.add(user)
        
        // When
        sut.remove(id: "1")
        
        // Then
        #expect(sut.load().isEmpty)
    }
}
