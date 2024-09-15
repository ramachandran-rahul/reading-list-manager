//
//  BookDetailView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.presentationMode) var presentationMode // To dismiss the view after deletion
    @State private var pagesReadInput: String = "" // To hold the pages read input
    @State private var isSaveDisabled: Bool = true // Disable save button if input is invalid
    
    var book: Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Book Image at the Top
                if let imagePath = book.imagePath, let image = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit() // Maintain aspect ratio and fit within the height
                        .frame(height: 210) // Fixed height, width adjusts dynamically
                        .cornerRadius(10) // Optional corner radius
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the image
                } else {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the image
                }

                // Book Title and Author with Favorite Star Icon
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("by \(book.author)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    // Star Icon Button to toggle isFavorite
                    Button(action: {
                        viewModel.toggleFavorite(for: book)
                    }) {
                        Image(systemName: book.isFavorite ? "star.fill" : "star")
                            .foregroundColor(book.isFavorite ? .yellow : .gray)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                }.padding(.top)

                // Genre
                Text("Genre: \(book.genre.rawValue)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                // Completion Percentage and Progress Bar
                VStack(alignment: .leading, spacing: 10) {
                    Text("Completion: \(Int(viewModel.completionPercentage(for: book)))%")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    ProgressView(value: viewModel.completionPercentage(for: book) / 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.bottom, 10)
                }

                // Pages Read Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Pages read:")
                            .font(.headline)
                        TextField("Enter pages", text: $pagesReadInput)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: pagesReadInput) { newValue in
                                pagesReadInput = newValue.filter { "0123456789".contains($0) }
                                
                                // Disable save button if input is invalid
                                if let pages = Int(pagesReadInput), pages <= book.totalPages {
                                    isSaveDisabled = false
                                } else {
                                    isSaveDisabled = true
                                }
                            }
                        
                        Text("/ \(book.totalPages)") // Total Pages (pre-filled)
                            .font(.headline)
                    }

                    // Save button to update pages read
                    Button(action: {
                        if let pages = Int(pagesReadInput), pages <= book.totalPages {
                            viewModel.updateProgress(for: book, newPagesRead: pages)
                        }
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save Progress")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isSaveDisabled ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .disabled(isSaveDisabled) // Disable when input is invalid
                    .padding(.top, 15)
                }
                .onAppear {
                    pagesReadInput = String(book.pagesRead) // Set initial value for pages read input
                }

                // Delete Book Button
                Button(action: {
                    viewModel.deleteBook(book)
                    presentationMode.wrappedValue.dismiss() // Close the detail view after deletion
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Delete Book")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}


struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(viewModel: BookViewModel(), book: Book(title: "Sample Book", author: "Sample Author", genre: .fiction, totalPages: 100, pagesRead: 50, isFavorite: false))
    }
}
