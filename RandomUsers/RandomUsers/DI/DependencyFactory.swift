//
//  DependencyFactory.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import Foundation

protocol DependencyFactory {
    func makeBlacklistViewModel() -> BlacklistViewModel
}
