//
//  PreviewContainer.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 20/4/26.
//

import Foundation

final class PreviewContainer: DependencyFactory {

    let blacklistRepository: BlacklistRepository
    let usersRepository: UsersRepository
    let blacklistStore: BlacklistStore
    
    init(
        users: [User] = [],
        blacklistUsers: [BlacklistUser] = [],
        pageSize: Int = 10,
        errorsByPage: [Int: Error] = [:],
        delay: TimeInterval = 0
    ) {
        self.blacklistRepository = MockBlacklistRepository(
            blacklistUsers: blacklistUsers
        )

        self.usersRepository = MockUserRepository(
            users: users,
            pageSize: pageSize,
            errorsByPage: errorsByPage,
            delay: delay
        )
        
        self.blacklistStore = BlacklistStore(repository: blacklistRepository)
    }
    
    func makeUsersViewModel() -> UsersViewModel {
        UsersViewModel(
            blacklistStore: blacklistStore,
            fetchUsersUseCase: FetchUsersUseCaseImpl(repository: usersRepository)
        )
    }

    func makeBlacklistViewModel() -> BlacklistViewModel {
        BlacklistViewModel(
            store: blacklistStore
        )
    }
}
