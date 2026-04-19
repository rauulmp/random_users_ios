//
//  UsersViewModel.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

import Foundation

@Observable
@MainActor
class UsersViewModel {
    
    var state: UsersViewState = .loading
    var isPaginating = false
    var paginationError: String?
    var hasMoreResults = true
    private var currentPage = 1
    var searchText: String = ""
    
    var filteredUsers: [User] {
        guard case .success(let users) = state else { return [] }
        guard !searchText.isEmpty else { return users }
        
        return users.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText) ||
            user.email.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let fetchUsersUseCase: FetchUsersUseCase
    
    init(fetchUsersUseCase: FetchUsersUseCase) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    func fetchUsers(force: Bool = false) async {
        if !force, case .success = state { return }
        
        state = .loading
        isPaginating = false
        paginationError = nil
        currentPage = 1
        hasMoreResults = true
        
        do {
            let newUsers = try await fetchUsersUseCase.execute(page: currentPage)
            state = .success(users: [].appendingUnique(contentsOf: newUsers))
        } catch (let error) {
            state = .error((error as? NetworkError)?.desc ?? "Unknown error")
        }
    }
    
    func refreshUsers() async {
        await fetchUsers(force: true)
    }
    
    func fetchNewPage(force: Bool = false) async {
        if force {
            paginationError = nil
        }
        
        guard case .success(let users) = state,
                !isPaginating,
                paginationError == nil,
                hasMoreResults,
                searchText.isEmpty else {
            return
        }

        isPaginating = true
        
        defer {
            isPaginating = false
        }
        
        do {
            let newUsers = try await fetchUsersUseCase.execute(page: currentPage + 1)
            guard !newUsers.isEmpty else {
                hasMoreResults = false
                return
            }
            
            currentPage += 1
            state = .success(users: users.appendingUnique(contentsOf: newUsers))
        } catch (let error) {
            state = .success(users: users)
            paginationError = (error as? NetworkError)?.desc ?? "Unknown error"
        }
    }
    
    func forceToFetchNewPage() async {
        await fetchNewPage(force: true)
    }
}
