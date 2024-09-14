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
    @ObservedObject var mainViewModel: BookViewModel // Main ViewModel for the book list

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
            
            // Add Book Button with Icon
            Button(action: {
                if let newBook = viewModel.createBook() {
                    mainViewModel.books.append(newBook)
                    mainViewModel.saveBooks()
                    presentationMode.wrappedValue.dismiss() // Close the form
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
}


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView(viewModel: AddBookViewModel(), mainViewModel: BookViewModel())
    }
}
