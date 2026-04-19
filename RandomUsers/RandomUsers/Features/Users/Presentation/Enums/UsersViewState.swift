//
//  UsersViewState.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

enum UsersViewState {
    case loading
    case success(users: [User])
    case error(String)
}
