//
//  Book.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import Foundation

struct Book: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var genre: Genre
    var totalPages: Int
    var pagesRead: Int
    var isFavorite: Bool

    enum Genre: String, CaseIterable {
        case fiction = "Fiction"
        case nonFiction = "Non-Fiction"
        case academic = "Academic"
    }
}
