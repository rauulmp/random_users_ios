//
//  MockBlacklistRepository.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

final class MockBlacklistRepository: BlacklistRepository {

    private var storage: [BlacklistUser] = []

    private(set) var addCount = 0
    private(set) var removeCount = 0
    private(set) var saveCount = 0
    private(set) var loadCount = 0

    init(blacklistUsers: [BlacklistUser] = []) {
        self.storage = blacklistUsers
    }

    func load() -> [BlacklistUser] {
        loadCount += 1
        return storage
    }

    func save(_ users: [BlacklistUser]) {
        saveCount += 1
        storage = users
    }

    func add(_ user: User) {
        addCount += 1

        let new = BlacklistUser(from: user)

        guard !storage.contains(where: { $0.id == new.id }) else { return }

        storage.append(new)
        save(storage)
    }

    func remove(id: String) {
        removeCount += 1
        storage.removeAll { $0.id == id }
        save(storage)
    }
}
