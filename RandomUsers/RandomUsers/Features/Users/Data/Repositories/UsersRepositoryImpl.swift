//
//  UsersRepositoryImpl.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import Foundation

struct UsersRepositoryImpl: UsersRepository {

    private let client: RandomUsersClient
    private let seed: String

    init(client: RandomUsersClient, seed: String = UUID().uuidString) {
        self.client = client
        self.seed = seed
    }

    func fetchUsers(page: Int) async throws -> [User] {
        let endpoint = Endpoint.users(
            page: page,
            numResults: 40,
            seed: seed
        )

        let response: UserResponseDTO = try await client.request(endpoint: endpoint)

        return response.results.map(UserMapper.map)
    }
}
