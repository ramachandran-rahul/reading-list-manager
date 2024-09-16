//
//  BookTileView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 16/09/24.
//

import SwiftUI

struct BookTileView: View {
    var book: Book
    @ObservedObject var viewModel: BookViewModel
    @Binding var selectedBook: Book?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Display book image if available, otherwise show a placeholder
                if let imagePath = book.imagePath, let image = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
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
                
                // Display completion percentage with a green background if fully completed
                Text("\(Int(viewModel.completionPercentage(for: book)))% Complete")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(viewModel.completionPercentage(for: book) == 100 ? Color.green : Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .padding([.bottom], 5)
                
                Divider()
                
                // Display book title and author, truncating if necessary
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
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
            .padding(5)
            .onTapGesture {
                selectedBook = book // Set the selected book to show details
            }
            
            // Toggle the favorite status of the book
            Button(action: {
                viewModel.toggleFavorite(for: book)
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
}

struct BookTileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBook = Book(title: "Sample Book", author: "Sample Author", genre: .fiction, totalPages: 300, pagesRead: 150, isFavorite: true, imagePath: nil)
        let viewModel = BookViewModel(books: [sampleBook])

        return BookTileView(book: sampleBook, viewModel: viewModel, selectedBook: .constant(sampleBook))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
