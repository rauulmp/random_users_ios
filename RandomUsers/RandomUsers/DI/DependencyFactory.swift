//
//  DependencyFactory.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

struct DependencyFactory {
    static func makeUsersViewModel() -> UsersViewModel {
        let client = RandomUsersClientImpl()
        let repository = UsersRepositoryImpl(client: client)
        let useCase = FetchUsersUseCaseImpl(repository: repository)
        return UsersViewModel(fetchUsersUseCase: useCase)
    }
    
    static func makeMockUsersViewModel(
        users: [User] = [],
        error: NetworkError? = nil
    ) -> UsersViewModel {
        let mockRepo = MockUserRepository(users: users, errorToThrow: error)
        let useCase = FetchUsersUseCaseImpl(repository: mockRepo)
        return UsersViewModel(fetchUsersUseCase: useCase)
    }
}
