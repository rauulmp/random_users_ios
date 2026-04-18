//
//  UsersRepositoryImpl.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

struct UsersRepositoryImpl: UsersRepository {
    
    private let client: RandomUsersClient
    
    init(client: RandomUsersClient) {
        self.client = client
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        let endpoint = Endpoint.users(page: page, numResults: 40)
        let response: UserResponseDTO = try await client.request(endpoint: endpoint)
        return response.results.map { UserMapper.map($0)}
    }
}
