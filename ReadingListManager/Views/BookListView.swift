//
//  BookListView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var viewModel: BookViewModel
    @State private var selectedBook: Book? // State to track the selected book
    @State private var showDetailSheet = false // State to control the sheet presentation
    @State private var selectedGenre: Book.Genre? = nil // State to track the selected genre
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if viewModel.books.isEmpty {
                VStack {
                    Text("You don't have any books yet!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    Text("Please go back and add a book to your collection.")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            } else {
                // Page Title
                Text("Your Book Collection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
                Text("Track your reading journey! Keep an eye on how many pages you've turned!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing, .bottom])
                
                // Genre Filter Picker
                VStack {
                    Picker("Select Genre", selection: $selectedGenre) {
                        Text("All").tag(Book.Genre?.none)
                        ForEach(Book.Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue).tag(Book.Genre?.some(genre))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                ScrollView {
                    Divider().padding(.bottom)

                    // Favourite Books Section
                    if !viewModel.filteredBooks(for: selectedGenre).filter({ $0.isFavorite }).isEmpty {
                        Text("Favourite Books")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.leading, .bottom], 10)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.filteredBooks(for: selectedGenre).filter { $0.isFavorite }) { book in
                                BookTileView(book: book, viewModel: viewModel, selectedBook: $selectedBook)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                    
                    Divider().padding(.vertical)
                    
                    // Other Books Section
                    if !viewModel.filteredBooks(for: selectedGenre).filter({ !$0.isFavorite }).isEmpty {
                        Text("Your Other Books")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.leading, .bottom], 10)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.filteredBooks(for: selectedGenre).filter { !$0.isFavorite }) { book in
                                BookTileView(book: book, viewModel: viewModel, selectedBook: $selectedBook)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            }
        }
        .background(Color(red: 183/255, green: 212/255, blue: 216/255).ignoresSafeArea())
        .sheet(item: $selectedBook) { selectedBook in
            // Present BookDetailView as a sheet, passing the book as a binding for real-time updates
            if let index = viewModel.books.firstIndex(where: { $0.id == selectedBook.id }) {
                BookDetailView(viewModel: viewModel, book: $viewModel.books[index])
            }
        }


    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        let book1 = Book(title: "1984", author: "George Orwell", genre: .fiction, totalPages: 328, pagesRead: 150, isFavorite: false, imagePath: nil)
        let book2 = Book(title: "Brave New World", author: "Aldous Huxley", genre: .fiction, totalPages: 268, pagesRead: 200, isFavorite: true, imagePath: nil)
        let book3 = Book(title: "Sapiens", author: "Yuval Noah Harari", genre: .nonFiction, totalPages: 443, pagesRead: 320, isFavorite: false, imagePath: nil)
        
        let viewModel = BookViewModel(books: [book1, book2, book3])
        
        return NavigationView {
            BookListView(viewModel: viewModel)
        }
    }
}
