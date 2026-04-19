//
//  DependencyFactory.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

struct DependencyFactory {
    static func makeUsersViewModel() -> UsersViewModel {
        let client = RandomUsersClientImpl()
        let repository = UsersRepositoryImpl(client: client)
        let useCase = FetchUsersUseCaseImpl(repository: repository)
        return UsersViewModel(fetchUsersUseCase: useCase)
    }
    
    static func makeMockUsersViewModel(
        users: [User] = [],
        pageSize: Int = 10,
        errorsByPage: [Int: Error] = [:],
        delay: TimeInterval = 0
    ) -> UsersViewModel {
        let mockRepo = MockUserRepository(users: users, pageSize: pageSize, errorsByPage: errorsByPage, delay: delay)
        let useCase = FetchUsersUseCaseImpl(repository: mockRepo)
        return UsersViewModel(fetchUsersUseCase: useCase)
    }
}
