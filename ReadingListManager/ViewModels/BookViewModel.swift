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
        loadBooks() // Load the saved books when the ViewModel is initialized
    }
    
    // Function to filter books based on the selected genre
    func filteredBooks(for genre: Book.Genre?) -> [Book] {
        if let genre = genre {
            return books.filter { $0.genre == genre }
        } else {
            return books // Return all books if no genre is selected
        }
    }

    // Function to toggle favorite status
    func toggleFavorite(for book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].toggleFavorite()
            saveBooks() // Save the books after toggling favorite
        }
    }

    // Function to update the reading progress
    func updateProgress(for book: Book, newPagesRead: Int) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].pagesRead = min(newPagesRead, books[index].totalPages)
            saveBooks() // Save the books after updating progress
        }
    }

    // Delete a book
    func deleteBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books.remove(at: index)
            saveBooks() // Save the books after deletion
        }
    }

    // Function to calculate the completion percentage
    func completionPercentage(for book: Book) -> Float {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            let totalPages = books[index].totalPages
            let pagesRead = books[index].pagesRead
            return totalPages > 0 ? (Float(pagesRead) / Float(totalPages)) * 100 : 0
        }
        return 0
    }

    // Save books to UserDefaults
    func saveBooks() {
        let bookData = books.map { book -> [String: Any] in
            return [
                "id": book.id.uuidString,
                "title": book.title,
                "author": book.author,
                "genre": book.genre.rawValue,
                "totalPages": book.totalPages,
                "pagesRead": book.pagesRead,
                "isFavorite": book.isFavorite,
                "imagePath": book.imagePath ?? ""
            ]
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: bookData, options: [])
            UserDefaults.standard.set(data, forKey: "bookList")
        } catch {
            print("Error saving books: \(error)")
        }
    }

    // Load books from UserDefaults
    func loadBooks() {
        guard let savedData = UserDefaults.standard.data(forKey: "bookList") else {
            return
        }

        do {
            if let savedBooks = try JSONSerialization.jsonObject(with: savedData, options: []) as? [[String: Any]] {
                self.books = savedBooks.map { dict in
                    let title = dict["title"] as? String ?? ""
                    let author = dict["author"] as? String ?? ""
                    let genre = Book.Genre(rawValue: dict["genre"] as? String ?? "Fiction") ?? .fiction
                    let totalPages = dict["totalPages"] as? Int ?? 0
                    let pagesRead = dict["pagesRead"] as? Int ?? 0
                    let isFavorite = dict["isFavorite"] as? Bool ?? false
                    let imagePath = dict["imagePath"] as? String ?? ""
                    let id = UUID(uuidString: dict["id"] as? String ?? UUID().uuidString) ?? UUID()
                    return Book(id: id, title: title, author: author, genre: genre, totalPages: totalPages, pagesRead: pagesRead, isFavorite: isFavorite, imagePath: imagePath)
                }
            }
        } catch {
            print("Error loading books: \(error)")
        }
    }
}
