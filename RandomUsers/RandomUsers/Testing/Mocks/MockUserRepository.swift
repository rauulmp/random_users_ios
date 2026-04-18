//
//  MockUserRepository.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import Foundation

class MockUserRepository: UsersRepository {
    let users: [User]
    let shouldReturnError: Bool
    
    init(users: [User] = [], shouldReturnError: Bool = false) {
        self.users = users
        self.shouldReturnError = shouldReturnError
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        if shouldReturnError {
            throw NetworkError.noConnection
        }
        return users
    }
}
