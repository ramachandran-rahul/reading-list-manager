//
//  AddBookViewModel.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import Foundation
import Combine
import UIKit

class AddBookViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var genre: Book.Genre = .fiction
    @Published var totalPages: String = ""
    
    @Published var imagePath: String?
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // Reset the fields after successful submission
    func resetFields() {
        title = ""
        author = ""
        genre = .fiction
        totalPages = ""
        imagePath = nil
    }
    
    // Validate the inputs
    func validateInputs() -> Bool {
        guard !title.isEmpty else {
            errorMessage = "Please enter a book title."
            return false
        }
        
        guard !author.isEmpty else {
            errorMessage = "Please enter the author's name."
            return false
        }
        
        guard let pages = Int(totalPages), pages > 0 else {
            errorMessage = "Please enter a valid number of pages."
            return false
        }
        
        return true
    }
    
    // Save image to documents directory
    func saveImageToDocuments(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = UUID().uuidString + ".jpg"
            let path = getDocumentsDirectory().appendingPathComponent(filename)

            do {
                try data.write(to: path)
                return path.path // Return the file path to store in UserDefaults or CoreData
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // Get the Documents Directory URL
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Check if the book already exists
    func doesBookAlreadyExist(in books: [Book]) -> Bool {
        return books.contains(where: {
            $0.title.caseInsensitiveCompare(title) == .orderedSame &&
            $0.author.caseInsensitiveCompare(author) == .orderedSame &&
            $0.genre == genre &&
            $0.totalPages == Int(totalPages)
        })
    }

    // Create a new Book object if inputs are valid
    func createBook(selectedImage: UIImage?, books: [Book]) -> Book? {
        if validateInputs() {
            if doesBookAlreadyExist(in: books) {
                errorMessage = "This book already exists in your collection."
                return nil
            }

            if let pages = Int(totalPages) {
                var newBook = Book(title: title, author: author, genre: genre, totalPages: pages, pagesRead: 0, isFavorite: false)
                
                if let image = selectedImage {
                    newBook.imagePath = saveImageToDocuments(image: image)
                }
                
                return newBook
            }
        }
        return nil
    }
}
