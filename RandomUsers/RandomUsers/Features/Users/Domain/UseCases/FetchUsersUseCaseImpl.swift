//
//  FetchUsersUseCaseImpl.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

struct FetchUsersUseCaseImpl: FetchUsersUseCase {
    
    private let repository: UsersRepository
    
    init(repository: UsersRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> [User] {
        try await repository.fetchUsers(page: page)
    }
}
