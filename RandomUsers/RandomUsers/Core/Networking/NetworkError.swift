//
//  NetworkError.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 17/4/26.
//

enum NetworkError: Error {
    case noConnection
    case badUrl
    case decoding
    case request
    
    var desc: String {
        switch self {
        case .noConnection: "There is no connection"
        case .badUrl: "Bad url"
        case .decoding: "Decoding error"
        case .request: "Request error"
        }
    }
}
