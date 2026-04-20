//
//  BlacklistStoreTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 20/4/26.
//

import Testing
@testable import RandomUsers

@Suite("Blacklist Store Tests")
@MainActor
struct BlacklistStoreTests {
    
    @Test("Adding a user updates the internal list")
    func testAddUpdatesList() {
        // Given
        let container = PreviewContainer()
        let sut = container.blacklistStore
        let user = User.mock(id: "1")
        
        guard let mockRepo = container.blacklistRepository as? MockBlacklistRepository else {
            Issue.record("The repository is not a MockBlacklistRepository")
            return
        }
        
        // When
        sut.add(user)
        
        // Then
        #expect(sut.users.count == 1)
        #expect(sut.users.first?.id == "1")
        #expect(mockRepo.addCount == 1)
    }

    @Test("Removing a user updates the internal list")
    func testRemoveUpdatesList() {
        // Given
        let user = BlacklistUser.mock(user: User.mock(id: "1"))
        let container = PreviewContainer(blacklistUsers: [user])
        let sut = container.blacklistStore
        
        guard let mockRepo = container.blacklistRepository as? MockBlacklistRepository else {
            Issue.record("The repository is not a MockBlacklistRepository")
            return
        }
        
        // When
        sut.remove(id: "1")
        
        // Then
        #expect(sut.users.isEmpty)
        #expect(mockRepo.removeCount == 1)
    }
}
