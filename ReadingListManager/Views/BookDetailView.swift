//
//  BookDetailView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var pagesReadInput: String = "" // To hold the pages read input
    @State private var isSaveDisabled: Bool = true // Disable save button if input is invalid
    @State private var showDeleteConfirmation = false // Show confirmation alert before deleting the book
    
    @Binding var book: Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display the book image or a placeholder if no image is available
                if let imagePath = book.imagePath, let image = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit() // Maintain aspect ratio and fit within the height
                        .frame(height: 210) // Fixed height, width adjusts dynamically
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
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

                // Display genre
                Text("Genre: \(book.genre.rawValue)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)

                // Completion Percentage and Progress Bar
                VStack(alignment: .leading, spacing: 10) {
                    // Show "Completed" and a green progress bar if book is fully read
                    if viewModel.completionPercentage(for: book) == 100 {
                        HStack {
                            Text("Completed")
                                .font(.headline)
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                        ProgressView(value: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                            .frame(height: 10)
                            .padding(.bottom, 10)
                    } else {
                        // Display percentage completion and progress bar if not fully read
                        Text("Completion: \(Int(viewModel.completionPercentage(for: book)))%")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        ProgressView(value: viewModel.completionPercentage(for: book) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                            .frame(height: 10)
                            .padding(.bottom, 10)
                    }
                }

                // Pages Read Section with input validation
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Pages read:")
                            .font(.headline)
                        TextField("Enter pages", text: $pagesReadInput)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: pagesReadInput) {
                                // Allow only numeric input
                                pagesReadInput = pagesReadInput.filter { "0123456789".contains($0) }
                                
                                // Disable save button if input is invalid
                                if let pages = Int(pagesReadInput), pages <= book.totalPages {
                                    isSaveDisabled = false
                                } else {
                                    isSaveDisabled = true
                                }
                            }
                        
                        Text("/ \(book.totalPages)") // Total pages
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
                    .disabled(isSaveDisabled) // Disable save when input is invalid
                    .padding(.top, 15)
                }
                .onAppear {
                    pagesReadInput = String(book.pagesRead) // Set initial value for pages read input
                }

                // Delete Book Button with confirmation alert
                Button(action: {
                    showDeleteConfirmation = true // Show confirmation alert before deleting
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
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Book"),
                        message: Text("Are you sure you want to delete this book?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteBook(book)
                            presentationMode.wrappedValue.dismiss() // Close the detail view after deletion
                        },
                        secondaryButton: .cancel() // Cancel the delete operation
                    )
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(title: "Sample Book", author: "Sample Author", genre: .fiction, totalPages: 100, pagesRead: 50, isFavorite: false)
        
        @State var bookState = book
        
        BookDetailView(viewModel: BookViewModel(), book: $bookState)
    }
}
