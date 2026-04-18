//
//  UserListView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import SwiftUI

struct UserListView: View {
    
    @State var viewModel: UsersViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    List(viewModel.userList) { user in
                        NavigationLink{
                            UserDetailView(user: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    let mockRepo = MockUserRepository(users: User.previewList)
    let useCase = FetchUsersUseCaseImpl(repository: mockRepo)
    let viewModel = UsersViewModel(fetchUsersUseCase: useCase)
    
    UserListView(viewModel: viewModel)
}
