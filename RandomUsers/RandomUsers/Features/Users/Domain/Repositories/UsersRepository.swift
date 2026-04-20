//
//  UsersRepository.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

protocol UsersRepository {
    func fetchUsers(page: Int) async throws -> [User]
}
