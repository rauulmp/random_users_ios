//
//  User.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import Foundation

struct User: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let pictureURL: URL
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
