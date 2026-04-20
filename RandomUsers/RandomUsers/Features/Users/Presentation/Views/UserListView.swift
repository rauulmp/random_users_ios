//
//  UserListView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import SwiftUI

struct UserListView: View {
    
    @State var viewModel: UsersViewModel
    let factory: DependencyFactory
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success:
                    if viewModel.filteredUsers.isEmpty && viewModel.searchText.isEmpty {
                         emptyStateView
                    } else if viewModel.filteredUsers.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    } else {
                        listView(users: viewModel.filteredUsers)
                    }
                case .error(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle("Users")
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search by name or email"
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .userDetail(let user):
                    UserDetailView(user: user)
                case .blacklist:
                    BlacklistView(viewModel: factory.makeBlacklistViewModel())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: AppRoute.blacklist) {
                        Image(systemName: "person.badge.minus")
                    }
                }
            }
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Users Found", systemImage: "person.slash")
        } description: {
            Text("There are no users to display at the moment.")
        } actions: {
            Button("Retry") {
                Task { await viewModel.retryFetchUsers() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.retryFetchUsers()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func listView(users: [User]) -> some View {
        List{
            ForEach(users) { user in
                NavigationLink(value: AppRoute.userDetail(user)) {
                    UserRowView(user: user)
                }
            }
            .onDelete(perform: viewModel.deleteUser)
            
            if viewModel.hasMoreResults && viewModel.searchText.isEmpty {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            Task {
                                await viewModel.fetchNewPage()
                            }
                        }
                    
                    if viewModel.isPaginating {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                    
                    if let error = viewModel.paginationError {
                        VStack(spacing: 8) {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                            
                            Button("Retry") {
                                Task {
                                    await viewModel.forceToFetchNewPage()
                                }
                            }
                            .font(.footnote)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
}

#Preview("User List View - Light Mode") {
    let container = PreviewContainer(users: User.previewList)
    UserListView(viewModel: container.makeUsersViewModel(), factory: container)
}

#Preview("User List View - Empty - Light Mode") {
    let container = PreviewContainer()
    UserListView(viewModel: container.makeUsersViewModel(), factory: container)
}

#Preview("User List View - Error - Light Mode") {
    let container = PreviewContainer(errorsByPage: [1: NetworkError.noConnection], delay: 0.5)
    UserListView(viewModel: container.makeUsersViewModel(), factory: container)
}

#Preview("User List View - Pagination Error - Light Mode") {
    let container = PreviewContainer(users: User.previewList)
    let viewModel = container.makeUsersViewModel()
    viewModel.state = .success(users: User.previewList)
    viewModel.paginationError = "Failed to load more users."
    return UserListView(viewModel: viewModel, factory: container)
}

#Preview("User List View - Dark Mode") {
    let container = PreviewContainer(users: User.previewList)
    UserListView(viewModel: container.makeUsersViewModel(), factory: container)
        .preferredColorScheme(.dark)
}
