//
//  BlacklistStore.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 20/4/26.
//

import Foundation

@Observable
final class BlacklistStore {

    private let repository: BlacklistRepository

    var users: [BlacklistUser] = []

    init(repository: BlacklistRepository) {
        self.repository = repository
        self.users = repository.load()
    }

    func refresh() {
        users = repository.load()
    }

    func remove(id: String) {
        repository.remove(id: id)
        refresh()
    }
    
    func add(_ user: User) {
        repository.add(user)
        refresh()
    }
}
