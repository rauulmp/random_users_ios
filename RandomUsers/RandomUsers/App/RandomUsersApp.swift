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
            UserListView(viewModel: DependencyFactory.makeUsersViewModel())
        }
    }
}
