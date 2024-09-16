//
//  Favouriteable.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 16/09/24.
//

import Foundation

protocol Favouriteable {
    var isFavorite: Bool { get set }
    
    mutating func toggleFavorite()
}

extension Favouriteable {
    mutating func toggleFavorite() {
        self.isFavorite.toggle()
    }
}
