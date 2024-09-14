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
        VStack(alignment: .leading, spacing: 30) {
            
            // Custom Title and Message
            Text("Add a New Book")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Add your current read here, we can't wait to hear all about it!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            
            // Image Picker Button and Display
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.top)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.top)
                }
                
                // Button to pick an image
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Upload Book Cover")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage) // Display the ImagePicker
                }
                
                // Button to clear the selected image
                if selectedImage != nil {
                    Button(action: {
                        selectedImage = nil // Clear the selected image
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Clear Book Cover")
                        }
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            
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
            
            Spacer()
            
            
            // Add Book Button
            Button(action: {
                if let newBook = viewModel.createBook() {
                    if let image = selectedImage {
                        let imagePath = saveImageToDocuments(image: image) // Save the image to the file system
                        var updatedBook = newBook
                        updatedBook.imagePath = imagePath // Store the path in the Book model
                        mainViewModel.books.append(updatedBook)
                    } else {
                        mainViewModel.books.append(newBook) // Add book without an image
                    }
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
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
        .background(Color(red: 183/255, green: 212/255, blue: 216/255).ignoresSafeArea())
    }
    
    // Save Image to Documents Directory and Return the Path
    func saveImageToDocuments(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = UUID().uuidString + ".jpg"
            let path = getDocumentsDirectory().appendingPathComponent(filename)
            
            do {
                try data.write(to: path)
                return path.path // Return the file path to store in UserDefaults
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
}



struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView(viewModel: AddBookViewModel(), mainViewModel: BookViewModel())
    }
}
