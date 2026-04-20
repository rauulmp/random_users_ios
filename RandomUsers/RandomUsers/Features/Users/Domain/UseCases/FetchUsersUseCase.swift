//
//  FetchUsersUseCase.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

protocol FetchUsersUseCase {
    func execute(page: Int) async throws -> [User] 
}
