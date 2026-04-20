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
    
    private var searchTask: Task<Void, Never>?
    var searchText: String = "" {
        didSet { debounceSearch() }
    }
    private(set) var debouncedSearchText: String = ""
    private let debounceDelay: UInt64
    
    var filteredUsers: [User] {
        guard case .success(let users) = state else { return [] }
        
        let blockedIds = Set(blacklistStore.users.map { $0.id })
        let activeUsers = users.filter { !blockedIds.contains($0.id) }
        guard !debouncedSearchText.isEmpty else { return activeUsers }
        
        return activeUsers.filter { user in
            user.name.localizedCaseInsensitiveContains(debouncedSearchText) ||
            user.email.localizedCaseInsensitiveContains(debouncedSearchText)
        }
    }
    
    private let blacklistStore: BlacklistStore
    private let fetchUsersUseCase: FetchUsersUseCase
    
    init(blacklistStore: BlacklistStore,
         fetchUsersUseCase: FetchUsersUseCase,
         debounceDelay: UInt64 = 400_000_000) {
        self.blacklistStore = blacklistStore
        self.fetchUsersUseCase = fetchUsersUseCase
        self.debounceDelay = debounceDelay
    }
    
    func fetchUsers(force: Bool = false, showLoading: Bool = true) async {
        if !force, case .success = state { return }
        
        if showLoading {
            state = .loading
        }
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
    
    func retryFetchUsers() async {
        await fetchUsers(force: true)
    }
    
    func refreshUsers() async {
        await fetchUsers(force: true, showLoading: false)
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
    
    func deleteUser(at offsets: IndexSet) {
        let usersToDelete = offsets.map { filteredUsers[$0] }
        
        for user in usersToDelete {
            blacklistStore.add(user)
        }
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        
        let current = searchText
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: debounceDelay)
            if Task.isCancelled { return }
            
            debouncedSearchText = current
        }
    }
}
