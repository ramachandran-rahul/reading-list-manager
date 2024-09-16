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
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    
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
                    .padding(.leading)
                // Fun Description
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
                                bookTile(for: book)
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
                                bookTile(for: book)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            }
        }
        .background(Color(red: 183/255, green: 212/255, blue: 216/255).ignoresSafeArea())
        .sheet(item: $selectedBook) { selectedBook in
            // Present BookDetailView as a sheet
            BookDetailView(viewModel: viewModel, book: selectedBook)
        }
    }
    
    // Create a tile for each book, with tap gesture to open details and a favourite toggle
    private func bookTile(for book: Book) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Book Image
                if let imagePath = book.imagePath, let image = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180) // Fixed height, width adjusts dynamically
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 180)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Completion Percentage
                Text("\(Int(viewModel.completionPercentage(for: book)))% Complete")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .padding([.bottom], 5)
                
                Divider() // Line between image and content
                
                // Book Title and Author
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.title)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.vertical, 5)
                .padding(.bottom, 5)
                .padding(.horizontal, 5)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4) // Shadow for depth
            .padding(5) // Padding around each item
            .onTapGesture {
                selectedBook = book // Set the selected book
                showDetailSheet.toggle() // Show the detail sheet
            }
            // Star Button to toggle isFavourite
            Button(action: {
                toggleFavourite(for: book)
            }) {
                Image(systemName: book.isFavorite ? "star.fill" : "star")
                    .foregroundColor(book.isFavorite ? .yellow : .gray)
                    .padding(7.5)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .padding([.top, .trailing], 10)
            }
        }
    }

    // Toggle isFavourite for a specific book
    private func toggleFavourite(for book: Book) {
        viewModel.toggleFavorite(for: book)
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
