//
//  UserMapper.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import Foundation

struct UserMapper {
    static func map(_ dto: UserDTO) -> User {
        User(
            id: dto.login.uuid,
            name: "\(dto.name.first) \(dto.name.last)",
            email: dto.email,
            phone: dto.phone,
            pictureURL: URL(string: dto.picture.large),
            thumbnailURL: URL(string: dto.picture.thumbnail),
            location: "\(dto.location.city), \(dto.location.country)",
            age: dto.dob.age
        )
    }
}
