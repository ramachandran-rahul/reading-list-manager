//
//  Favouriteable.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 16/09/24.
//

import Foundation

// Protocol to define any object that can be marked as a favorite
protocol Favouriteable {
    var isFavorite: Bool { get set }
    
    // Method to toggle the favorite status
    mutating func toggleFavorite()
}

// Default implementation of the toggleFavorite method for all types conforming to Favouriteable
extension Favouriteable {
    mutating func toggleFavorite() {
        self.isFavorite.toggle()
    }
}
