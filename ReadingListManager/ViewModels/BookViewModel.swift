//
//  BookViewModel.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []

    init(books: [Book] = []) {
        self.books = books
    }

    // Function to toggle favorite status
    func toggleFavorite(for book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorite.toggle()
        }
    }

    // Function to update the reading progress
    func updateProgress(for book: Book, newPagesRead: Int) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].pagesRead = min(newPagesRead, books[index].totalPages)
        }
    }

    // Function to calculate the completion percentage
    func completionPercentage(for book: Book) -> Float {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            let totalPages = books[index].totalPages
            let pagesRead = books[index].pagesRead
            return (Float(pagesRead) / Float(totalPages)) * 100
        }
        return 0
    }

    // Optionally, add methods to filter books by genre
    func filterBooks(by genre: Book.Genre) -> [Book] {
        return books.filter { $0.genre == genre }
    }

    // Save books to UserDefaults
    func saveBooks() {
        let bookData = books.map { book -> [String: Any] in
            return [
                "title": book.title,
                "author": book.author,
                "genre": book.genre.rawValue,
                "totalPages": book.totalPages,
                "pagesRead": book.pagesRead,
                "isFavorite": book.isFavorite
            ]
        }
        UserDefaults.standard.set(bookData, forKey: "bookList")
    }

    // Load books from UserDefaults
    func loadBooks() {
        if let savedBooks = UserDefaults.standard.array(forKey: "bookList") as? [[String: Any]] {
            self.books = savedBooks.map { dict in
                let title = dict["title"] as? String ?? ""
                let author = dict["author"] as? String ?? ""
                let genre = Book.Genre(rawValue: dict["genre"] as? String ?? "Fiction") ?? .fiction
                let totalPages = dict["totalPages"] as? Int ?? 0
                let pagesRead = dict["pagesRead"] as? Int ?? 0
                let isFavorite = dict["isFavorite"] as? Bool ?? false
                return Book(title: title, author: author, genre: genre, totalPages: totalPages, pagesRead: pagesRead, isFavorite: isFavorite)
            }
        }
    }
}
