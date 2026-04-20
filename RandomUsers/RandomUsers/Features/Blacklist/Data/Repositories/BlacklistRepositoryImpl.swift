//
//  BlacklistRepositoryImpl.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

final class BlacklistRepositoryImpl: BlacklistRepository {

    private let storage: UserDefaults
    private let key = "blacklist"
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    func load() -> [BlacklistUser] {
        guard let data = storage.data(forKey: key),
              let list = try? JSONDecoder().decode([BlacklistUser].self, from: data) else {
            return []
        }
        return list
    }

    func save(_ users: [BlacklistUser]) {
        let data = try? JSONEncoder().encode(users)
        storage.set(data, forKey: key)
    }

    func add(_ user: User) {
        var current = load()
        let new = BlacklistUser(from: user)

        guard !current.contains(where: { $0.id == new.id }) else { return }

        current.append(new)
        save(current)
    }

    func remove(id: String) {
        var current = load()
        current.removeAll { $0.id == id }
        save(current)
    }
}
