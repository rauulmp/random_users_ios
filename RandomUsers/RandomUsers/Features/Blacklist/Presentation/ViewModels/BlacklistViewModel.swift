//
//  BlacklistViewModel.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

@MainActor
class BlacklistViewModel {
    
    private let store: BlacklistStore

    init(store: BlacklistStore) {
        self.store = store
    }

    var blockedUsers: [BlacklistUser] {
        store.users
    }

    func removeUser(at offsets: IndexSet) {
        let users = offsets.map { store.users[$0] }

        for user in users {
            store.remove(id: user.id)
        }
    }
}
