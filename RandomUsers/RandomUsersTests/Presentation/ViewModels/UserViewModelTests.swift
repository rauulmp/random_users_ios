//
//  UserViewModelTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Testing
@testable import RandomUsers

@MainActor
@Suite("UsersViewModel State Tests")
struct UsersViewModelTests {
    
    @Test("Initial fetch success updates state to success")
    func testFetchUsersSuccess() async {
        // Given
        let testUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let sut = DependencyFactory.makeMockUsersViewModel(users: testUsers)
        
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
        let sut = DependencyFactory.makeMockUsersViewModel(errorsByPage: [1: NetworkError.noConnection])
        
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
        let allUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let sut = DependencyFactory.makeMockUsersViewModel(users: allUsers, pageSize: 1)
        
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
        let sut = DependencyFactory.makeMockUsersViewModel(users: [User.mock(id: "1")], pageSize: 10)
        
        // When
        await sut.fetchUsers()
        await sut.fetchNewPage()
        
        // Then
        #expect(sut.hasMoreResults == false)
    }
    
    @Test("Pagination error preserves current list")
    func testPaginationFailure() async {
        // Given
        let allUsers = [User.mock(id: "1"), User.mock(id: "2")]
        let sut = DependencyFactory.makeMockUsersViewModel(users: allUsers,
                                                           pageSize: 1,
                                                           errorsByPage: [2: NetworkError.noConnection])
       
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
        let allUsers = [User.mock(id: "1"), User.mock(id: "2"), User.mock(id: "3")]
        let mockRepo = MockUserRepository(users: allUsers, pageSize: 1, delay: 0.2)
        let useCase = FetchUsersUseCaseImpl(repository: mockRepo)
        let sut = UsersViewModel(fetchUsersUseCase: useCase)
        
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
}
