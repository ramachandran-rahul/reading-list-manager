//
//  AddBookView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddBookViewModel
    @ObservedObject var mainViewModel: BookViewModel
    
    @State private var selectedImage: UIImage? // Holds the selected image
    @State private var isImagePickerPresented = false // Controls Image Picker presentation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Custom Title and Message
                Text("Add a New Book")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Add your current read here, we can't wait to hear all about it!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                // Image/Placeholder acting as an upload button
                VStack {
                    Button(action: {
                        isImagePickerPresented.toggle() // Trigger the image picker when the image/placeholder is tapped
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 210, maxHeight: 280)
                                .clipShape(Rectangle())
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 1))
                                .padding(.top, 10)
                        } else {
                            VStack {
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                
                                Text("Tap to upload an image")
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .padding(.trailing)
                            }
                            .padding(.leading, 3)
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(image: $selectedImage) // Display the ImagePicker
                    }
                    
                    // Delete Button (only shown if an image is selected)
                    if selectedImage != nil {
                        Button(action: {
                            selectedImage = nil // Clear the selected image
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                // Form Fields
                VStack(spacing: 20) {
                    // Title Input
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Book Title")
                            .font(.headline)
                        TextField("Enter the book title", text: $viewModel.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.subheadline)
                    }
                    
                    // Author Input
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Author")
                            .font(.headline)
                        TextField("Enter the author's name", text: $viewModel.author)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.subheadline)
                    }
                    
                    // Genre Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Genre")
                            .font(.headline)
                        Picker("Select a Genre", selection: $viewModel.genre) {
                            ForEach(Book.Genre.allCases, id: \.self) { genre in
                                Text(genre.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Better visual appearance
                    }
                    
                    // Total Pages Input
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Total Pages")
                            .font(.headline)
                        TextField("Enter the number of pages", text: $viewModel.totalPages)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.subheadline)
                    }
                }
                
                // Add Book Button
                Button(action: {
                    // Pass the selected image to the createBook function
                    if let newBook = viewModel.createBook(selectedImage: selectedImage, books: mainViewModel.books) {
                        mainViewModel.books.append(newBook)
                        mainViewModel.saveBooks()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        viewModel.showError.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                        Text("Add Book")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 5)
                }
                .alert(isPresented: $viewModel.showError) {
                    Alert(title: Text("Invalid Input"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 30)
        }
        .background(Color(red: 183/255, green: 212/255, blue: 216/255).ignoresSafeArea())
    }
}


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView(viewModel: AddBookViewModel(), mainViewModel: BookViewModel())
    }
}
