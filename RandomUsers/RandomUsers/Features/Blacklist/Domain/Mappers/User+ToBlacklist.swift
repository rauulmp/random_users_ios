//
//  User+ToBlacklist.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

extension BlacklistUser {
    init(from user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
    }
}
