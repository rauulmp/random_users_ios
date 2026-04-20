//
//  UserViewModelTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Testing
@testable import RandomUsers

@Suite("UsersViewModel State Tests")
@MainActor
struct UsersViewModelTests {
    
    @Test("Initial fetch success updates state to success")
    func testFetchUsersSuccess() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        
        // When
        await sut.fetchUsers()
        
        // Then
        if case .success(let users) = sut.state {
            #expect(users == testUsers)
        } else {
            Issue.record("State should be success")
        }
    }
    
    @Test("Initial fetch failure updates state to error")
    func testFetchUsersError() async {
        // Given
        let container = PreviewContainer(errorsByPage: [1: NetworkError.noConnection])
        let sut = container.makeUsersViewModel()
        
        // When
        await sut.fetchUsers()
        
        // Then
        if case .error = sut.state {
            #expect(true)
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test("Pagination success appends data correctly")
    func testPaginationAppendsData() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let container = PreviewContainer(users: testUsers, pageSize: 1)
        let sut = container.makeUsersViewModel()
        
        // When
        await sut.fetchUsers()
        await sut.fetchNewPage()
        
        // Then
        if case .success(let users) = sut.state {
            #expect(users.count == 2)
            #expect(users.map(\.id) == ["1", "2"])
        } else {
            Issue.record("Expected success state with appended data")
        }
    }
    
    @Test("Pagination stops when no more results")
    func testPaginationStopsOnEmpty() async {
        // Given
        let testUsers = [User.mock(id: "1")]
        let container = PreviewContainer(users: testUsers, pageSize: 10)
        let sut = container.makeUsersViewModel()
        
        // When
        await sut.fetchUsers()
        await sut.fetchNewPage()
        
        // Then
        #expect(sut.hasMoreResults == false)
    }
    
    @Test("Pagination error preserves current list")
    func testPaginationFailure() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let container = PreviewContainer(users: testUsers,
                                         pageSize: 1,
                                         errorsByPage: [2: NetworkError.noConnection])
        let sut = container.makeUsersViewModel()
       
        // When
        await sut.fetchUsers()
        await sut.fetchNewPage()
        
        // Then
        if case .success(let users) = sut.state {
            #expect(users.count == 1)
            #expect(sut.paginationError != nil)
        } else {
            Issue.record("Expected success state preserving existing users")
        }
    }
    
    @Test("FetchNewPage should ignore concurrent calls when already paginating")
    func testFetchNewPageReentrancy() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2"), User.mock(id: "3")]
        let container = PreviewContainer(users: testUsers, pageSize: 1, delay: 0.2)
        let sut = container.makeUsersViewModel()
        
        guard let mockRepo = container.usersRepository as? MockUserRepository else {
            Issue.record("The repository is not a MockUserRepository")
            return
        }
        
        // When
        await sut.fetchUsers()
        async let firstNewPageCall: () = sut.fetchNewPage()
        async let secondNewPageCall: () = sut.fetchNewPage()
        
        _ = await [firstNewPageCall, secondNewPageCall]
        
        // Then
        if case .success(let users) = sut.state {
            #expect(users.count == 2)
            #expect(users.map(\.id) == ["1", "2"])
            #expect(mockRepo.callCount == 2) //Initial + FirstNewPage
        } else {
            Issue.record("Expected success state with appended data")
        }
    }
    
    @Test("Filtering by name returns correct user")
    func testFilterByName() async {
        // Given
        let testUsers = [User.mock(name: "Alex Martinez", email: "alex@test.com"),
                         User.mock(name: "Raul Alonso", email: "raul@test.com")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        
        // When
        sut.searchText = "Alex"
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(sut.filteredUsers.count == 1)
        #expect(sut.filteredUsers.first?.name == "Alex Martinez")
    }

    @Test("Filtering is case insensitive")
    func testFilterCaseInsensitive() async {
        // Given
        let testUsers = [User.mock(name: "Alex Martinez", email: "alex@test.com"),
                         User.mock(name: "Raul Alonso", email: "raul@test.com")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        
        // When
        sut.searchText = "alex"
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(sut.filteredUsers.count == 1)
        #expect(sut.filteredUsers.first?.name == "Alex Martinez")
    }

    @Test("Filtering by email returns correct user")
    func testFilterByEmail() async {
        // Given
        let testUsers = [User.mock(name: "Alex Martinez", email: "alex@test.com"),
                         User.mock(name: "Raul Alonso", email: "raul@test.com")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        
        // When
        sut.searchText = "alex@test"
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(sut.filteredUsers.count == 1)
        #expect(sut.filteredUsers.first?.email == "alex@test.com")
    }

    @Test("Filtering with no match returns empty list")
    func testFilterNoResults() async {
        // Given
        let testUsers = [User.mock(name: "Alex", email: "alex@test.com")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        
        // When
        sut.searchText = "NonExistentUser"
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(sut.filteredUsers.isEmpty)
    }
    
    @Test("Filtering resets when search text is cleared")
    func testFilterResets() async {
        // Given
        let testUsers = [User.mock(name: "Alex Martinez", email: "alex@test.com"),
                         User.mock(name: "Raul Alonso", email: "raul@test.com")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        sut.searchText = "Alex"
        try? await Task.sleep(for: .milliseconds(100))
        #expect(sut.filteredUsers.count == 1)
        
        // When
        sut.searchText = ""
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(sut.filteredUsers.count == 2)
    }
    
    @Test("Filtering logic reacts to BlacklistStore changes")
    func testFilteringWithBlacklist() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let container = PreviewContainer(users: testUsers)
        let sut = container.makeUsersViewModel()
        await sut.fetchUsers()
        
        // When
        container.blacklistStore.add(testUsers.first!)
        
        // Then
        #expect(sut.filteredUsers.count == 1)
        #expect(sut.filteredUsers.first?.id == "2")
    }
}
