//
//  BlacklistRepository.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

protocol BlacklistRepository {
    func load() -> [BlacklistUser]
    func save(_ users: [BlacklistUser])
    func add(_ user: User)
    func remove(id: String)
}
