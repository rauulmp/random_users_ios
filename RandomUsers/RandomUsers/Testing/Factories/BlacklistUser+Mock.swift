//
//  BlacklistUser+Mock.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

extension BlacklistUser {
    static func mock(user: User = .mock()) -> BlacklistUser {
        return BlacklistUser(from: user)
    }
}

#if DEBUG
extension BlacklistUser {
    static let previewList = User.previewList.map { BlacklistUser(from: $0) }
}
#endif
