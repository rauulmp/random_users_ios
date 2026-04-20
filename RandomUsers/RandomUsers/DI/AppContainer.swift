//
//  AppContainer.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 20/4/26.
//

final class AppContainer: DependencyFactory {

    let blacklistRepository: BlacklistRepository = BlacklistRepositoryImpl()

    lazy var blacklistStore: BlacklistStore = {
        BlacklistStore(repository: blacklistRepository)
    }()
    
    lazy var usersRepository: UsersRepository = {
        UsersRepositoryImpl(client: randomUsersClient)
    }()

    lazy var randomUsersClient: RandomUsersClient = {
        RandomUsersClientImpl()
    }()
    
    func makeUsersViewModel() -> UsersViewModel {
        UsersViewModel(
            blacklistStore: blacklistStore,
            fetchUsersUseCase: FetchUsersUseCaseImpl(repository: usersRepository)
        )
    }
    
    func makeBlacklistViewModel() -> BlacklistViewModel {
        BlacklistViewModel(store: blacklistStore)
    }
}
