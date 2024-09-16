//
//  Book.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import Foundation

struct Book: Identifiable, Favouriteable {
    var id = UUID()
    var title: String
    var author: String
    var genre: Genre
    var totalPages: Int
    var pagesRead: Int
    var isFavorite: Bool
    var imagePath: String?

    enum Genre: String, CaseIterable {
        case fiction = "Fiction"
        case nonFiction = "Non-Fiction"
        case academic = "Academic"
    }
}
