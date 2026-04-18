//
//  RandomUsersClient.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import Foundation

protocol RandomUsersClient {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

class RandomUsersClientImpl: RandomUsersClient {
    
    let baseUrl = "https://randomuser.me"
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: baseUrl + endpoint.path) else {
            throw NetworkError.badUrl
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.request
        }
    }
}
