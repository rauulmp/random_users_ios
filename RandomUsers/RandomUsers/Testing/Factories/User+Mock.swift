//
//  User+Mock.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import Foundation

extension User {
    private static let defaultPictureURL = URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
    private static let defaultThumbnailURL = URL(string: "https://randomuser.me/api/portraits/thumb/men/1.jpg")
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Alex Martinez",
        email: String = "alex@email.com",
        phone: String = "600000000",
        pictureURL: URL? = defaultPictureURL,
        thumbnailURL: URL? = defaultThumbnailURL,
        location: String = "Barcelona, Spain",
        age: Int = 30
        
    ) -> User {
        User(
            id: id,
            name: name,
            email: email,
            phone: phone,
            pictureURL: pictureURL,
            thumbnailURL: thumbnailURL,
            location: location,
            age: age
        )
    }
}

#if DEBUG
extension User {
    static let preview = User.mock()
    
    static let previewList = [
        User.mock(name: "Alex Martinez", email: "alex@email.com", phone: "600000000", age: 27),
        User.mock(name: "Raul Alonso", email: "raul@email.com", phone: "611111111", age: 29),
        User.mock(name: "Elena Rodríguez", email: "elena@email.com", phone: "622222222", age: 34),
        User.mock(name: "Javier López", email: "javier@email.com", phone: "633333333", age: 45),
        User.mock(name: "Sofia Fernández", email: "sofia@email.com", phone: "644444444", age: 22),
        User.mock(name: "Diego Martínez", email: "diego@email.com", phone: "655555555", age: 50)
    ]
}
#endif
