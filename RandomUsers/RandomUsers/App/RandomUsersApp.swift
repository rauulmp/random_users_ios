//
//  RandomUsersApp.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import SwiftUI

@main
struct RandomUsersApp: App {

    let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: container.makeUsersViewModel(),
                         factory: container)
        }
    }
}
