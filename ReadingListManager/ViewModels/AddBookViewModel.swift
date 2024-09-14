//
//  AddBookViewModel.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import Foundation
import Combine

class AddBookViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var genre: Book.Genre = .fiction
    @Published var totalPages: String = ""
    
    @Published var imagePath: String? // Add the imagePath property to store the file path
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

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
    
    // Create a new Book object if inputs are valid
    func createBook() -> Book? {
        if validateInputs() {
            if let pages = Int(totalPages) {
                return Book(title: title, author: author, genre: genre, totalPages: pages, pagesRead: 0, isFavorite: false)
            }
        }
        return nil
    }
}
