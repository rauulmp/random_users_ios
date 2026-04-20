//
//  UserDTOs.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

struct UserResponseDTO: Decodable {
    let results: [UserDTO]
}

struct UserDTO: Decodable {
    let login: LoginDTO
    let name: NameDTO
    let email: String
    let phone: String
    let picture: PictureDTO
    let gender: String
    let dob: DobDTO
    let location: LocationDTO
}

struct LoginDTO: Decodable {
    let uuid: String
}

struct NameDTO: Decodable {
    let first: String
    let last: String
}

struct PictureDTO: Decodable {
    let large: String
    let thumbnail: String
}

struct DobDTO: Decodable {
    let age: Int
}

struct LocationDTO: Decodable {
    let city: String
    let country: String
}
