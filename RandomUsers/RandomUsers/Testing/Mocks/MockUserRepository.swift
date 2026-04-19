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
    private let errorsByPage: [Int: Error]
    var delay: TimeInterval
    private(set) var callCount = 0
    
    init(users: [User] = [],
         pageSize: Int = 10,
         errorsByPage: [Int: Error] = [:],
         delay: TimeInterval = 0.5) {
        
        self.users = users
        self.pageSize = pageSize
        self.errorsByPage = errorsByPage
        self.delay = delay
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        callCount += 1
        try await Task.sleep(for: .seconds(delay))
        
        if let error = errorsByPage[page] {
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
