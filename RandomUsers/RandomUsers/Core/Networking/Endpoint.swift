//
//  Endpoint.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

enum Endpoint {
    case users(page: Int, numResults: Int, seed: String)
    
    var path: String {
    switch self {
        case let .users(page, numResults, seed):
            return "/api/?results=\(numResults)&page=\(page)&seed=\(seed)"
        }
    }
}
