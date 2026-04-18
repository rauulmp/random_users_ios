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
    
    var userList: [User] = []
    var isLoading = false
    var errorMessage: String?
    
    private let fetchUsersUseCase: FetchUsersUseCase
    
    init(fetchUsersUseCase: FetchUsersUseCase) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            userList = try await fetchUsersUseCase.execute(page: 1)
        } catch (let error){
            errorMessage = (error as? NetworkError)?.desc
        }
        isLoading = false
    }
    
}
