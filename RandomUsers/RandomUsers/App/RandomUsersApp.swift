//
//  RandomUsersApp.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import SwiftUI

@main
struct RandomUsersApp: App {
    var body: some Scene {
        WindowGroup {
            let client = RandomUsersClientImpl()
            let repository = UsersRepositoryImpl(client: client)
            let useCase = FetchUsersUseCaseImpl(repository: repository)
            let viewModel = UsersViewModel(fetchUsersUseCase: useCase)
            
            UserListView(viewModel: viewModel)
        }
    }
}
