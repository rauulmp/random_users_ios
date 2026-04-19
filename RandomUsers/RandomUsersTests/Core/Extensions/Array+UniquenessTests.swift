//
//  Array+UniquenessTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Testing
@testable import RandomUsers

@Suite("Array Uniqueness Tests")
@MainActor 
struct ArrayUniquenessTests {
    
    @Test("appendingUnique maintains order and removes duplicates")
    func testAppendingUnique() {
        // Given
        let existing = [User.mock(id: "1"), User.mock(id: "2")]
        let new = [User.mock(id: "2"), User.mock(id: "3")]
        
        // When
        let result = existing.appendingUnique(contentsOf: new)
        
        // Then
        #expect(result.count == 3)
        #expect(result.map(\.id) == ["1", "2", "3"])
    }
    
    @Test("appendingUnique handles internal duplicates in batch")
    func testInternalDuplicates() {
        let existing: [User] = []
        let new = [User.mock(id: "1"), User.mock(id: "1")]
        
        let result = existing.appendingUnique(contentsOf: new)
        
        #expect(result.count == 1)
        #expect(result.first?.id == "1")
    }
}
