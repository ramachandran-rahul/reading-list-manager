//
//  HomeView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 13/09/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var mainViewModel = BookViewModel()
    @StateObject private var addBookViewModel = AddBookViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                VStack(spacing: 5) {
                    Image("PageMate")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    
                    Text("PageKeeper")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 15)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 5)
                    
                    Text("\"Track Your Reads, One Page at a Time\"")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                        .padding(.bottom, 30)
                    
                }
                Spacer()
                
                NavigationLink(destination: BookListView(viewModel: mainViewModel)) {
                    HStack {
                        Image(systemName: "text.book.closed.fill").font(.title2).padding(.trailing, 5)
                        Text("View Books")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .top, endPoint: .bottom))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 6)
                    .padding(.horizontal, 40)
                }
                
                // Button to add a new book
                NavigationLink(destination: AddBookView(viewModel: addBookViewModel, mainViewModel: mainViewModel)) {
                    HStack {
                        Image(systemName: "plus.square.fill").font(.title2).padding(.trailing, 5)
                        Text("Add Book")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]), startPoint: .top, endPoint: .bottom))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 6)
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding(.top, 40)
            .background(Color(red: 183/255, green: 212/255, blue: 216/255).ignoresSafeArea())
        }
        .onAppear {
            mainViewModel.loadBooks()
        }
    }
}

#Preview {
    HomeView()
}
