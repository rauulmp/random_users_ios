//
//  Array+Uniqueness.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

extension Array where Element: Identifiable {
    func appendingUnique(contentsOf newElements: [Element]) -> [Element] {
        var seenIds = Set(self.map { $0.id })
        
        let uniqueNewElements = newElements.filter {
            seenIds.insert($0.id).inserted
        }
        
        return self + uniqueNewElements
    }
}
