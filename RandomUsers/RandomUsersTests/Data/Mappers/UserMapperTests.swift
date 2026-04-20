//
//  UserMapperTests.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Testing
import Foundation
@testable import RandomUsers

@Suite("User Mapper Tests")
@MainActor
struct UserMapperTests {
    
    @Test("UserMapper maps DTO fields correctly")
    func testMapperMapping() {
        // Given
        let id = UUID().uuidString
        let dto = UserDTO(
            login: LoginDTO(uuid: id),
            name: NameDTO(first: "Alex", last: "Martinez"),
            email: "alex@email.com",
            phone: "600000000",
            picture: PictureDTO(large: "https://picture.url", thumbnail: "https://thumb.url"),
            gender: "male",
            dob: DobDTO(age: 30),
            location: LocationDTO(city: "Barcelona", country: "Spain")
        )
        
        // When
        let user = UserMapper.map(dto)
        
        // Then
        #expect(user.id == id)
        #expect(user.name == "Alex Martinez")
        #expect(user.email == "alex@email.com")
        #expect(user.phone == "600000000")
        #expect(user.pictureURL?.absoluteString == "https://picture.url")
        #expect(user.thumbnailURL?.absoluteString == "https://thumb.url")
        #expect(user.location == "Barcelona, Spain")
        #expect(user.age == 30)
    }
}
