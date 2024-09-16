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
        loadBooks() // Load the saved books when the ViewModel is initialised
    }
    
    // Filter books based on the selected genre, or return all books if no genre is selected
    func filteredBooks(for genre: Book.Genre?) -> [Book] {
        if let genre = genre {
            return books.filter { $0.genre == genre }
        } else {
            return books // Return all books if no genre is selected
        }
    }

    // Toggle the favorite status of the book, then save the changes
    func toggleFavorite(for book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].toggleFavorite()
            saveBooks() // Save the books after toggling favorite status
        }
    }

    // Update the reading progress of the book and ensure pages read does not exceed total pages
    func updateProgress(for book: Book, newPagesRead: Int) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].pagesRead = min(newPagesRead, books[index].totalPages)
            saveBooks() // Save the books after updating progress
        }
    }

    // Delete a book from the list and save the updated list
    func deleteBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books.remove(at: index)
            saveBooks() // Save the books after deletion
        }
    }

    // Calculate the completion percentage for a book, ensuring the totalPages is non-zero
    func completionPercentage(for book: Book) -> Float {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            let totalPages = books[index].totalPages
            let pagesRead = books[index].pagesRead
            return totalPages > 0 ? (Float(pagesRead) / Float(totalPages)) * 100 : 0
        }
        return 0
    }

    // Save books to UserDefaults by serializing the books array into JSON
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
                "imagePath": book.imagePath ?? "" // Handle the optional image path
            ]
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: bookData, options: [])
            UserDefaults.standard.set(data, forKey: "bookList")
        } catch {
            print("Error saving books: \(error)")
        }
    }

    // Load books from UserDefaults by deserializing the stored JSON into Book objects
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
