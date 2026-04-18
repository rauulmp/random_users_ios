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
    let pictureURL: URL?
    let thumbnailURL: URL?
    let location: String
    let age: Int
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
