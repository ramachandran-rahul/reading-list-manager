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
            // Page Title
            Text("Your Book Collection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            
            // Fun Description
            Text("Track your reading journey! Keep an eye on how many pages you've turned!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding([.leading, .trailing, .bottom])
            
            // Genre Filter Picker
            HStack {
                Text("Filter by Genre:")
                    .font(.headline)
                Picker("Select Genre", selection: $selectedGenre) {
                    Text("All").tag(Book.Genre?.none)
                    ForEach(Book.Genre.allCases, id: \.self) { genre in
                        Text(genre.rawValue).tag(Book.Genre?.some(genre))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            ScrollView {
                // Favourite Books Section
                if !filteredBooks.filter({ $0.isFavorite }).isEmpty {
                    Text("Favourite Books:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding([.leading, .bottom], 10)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredBooks.filter { $0.isFavorite }) { book in
                            bookTile(for: book)
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                // Other Books Section
                if !filteredBooks.filter({ !$0.isFavorite }).isEmpty {
                    Text("Your Other Books:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding([.leading, .bottom], 10)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredBooks.filter { !$0.isFavorite }) { book in
                            bookTile(for: book)
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
        }
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
                        .frame(width: 100, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // Overlay Completion Percentage
                VStack {
                    Spacer()
                    Text("\(Int(viewModel.completionPercentage(for: book)))% Complete")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                        .padding([.bottom], 10)
                }
                
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
    
    // Filtered books based on the selected genre
    private var filteredBooks: [Book] {
        if let selectedGenre = selectedGenre {
            return viewModel.books.filter { $0.genre == selectedGenre }
        } else {
            return viewModel.books // If no genre is selected, return all books
        }
    }

    // Toggle isFavourite for a specific book
    private func toggleFavourite(for book: Book) {
        if let index = viewModel.books.firstIndex(where: { $0.id == book.id }) {
            viewModel.books[index].isFavorite.toggle() // Toggle the isFavorite property
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
