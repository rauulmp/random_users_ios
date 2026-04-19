//
//  MockUserRepository.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import Foundation

class MockUserRepository: UsersRepository {
    private let users: [User]
    private let pageSize: Int
    var errorToThrow: Error?
    var delay: TimeInterval
    
    init(users: [User] = [],
         pageSize: Int = 10,
         errorToThrow: Error? = nil,
         delay: TimeInterval = 0.5) {
        
        self.users = users
        self.pageSize = pageSize
        self.errorToThrow = errorToThrow
        self.delay = delay
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        try await Task.sleep(for: .seconds(delay))
        
        if let error = errorToThrow {
            throw error
        }
        
        let startIndex = (page - 1) * pageSize
        
        guard startIndex < users.count else {
            return []
        }
        
        let endIndex = min(startIndex + pageSize, users.count)
        return Array(users[startIndex..<endIndex])
    }
}
