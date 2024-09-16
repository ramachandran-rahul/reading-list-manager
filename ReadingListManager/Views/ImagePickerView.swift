//
//  ImagePickerView.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 16/09/24.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var isImagePickerPresented = false // Controls Image Picker presentation
    
    var body: some View {
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
                    .padding(.top, 5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
    }
}


struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(selectedImage: .constant(nil))
    }
}
