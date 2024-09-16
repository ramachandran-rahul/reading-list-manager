//
//  ImagePicker.swift
//  ReadingListManager
//
//  Created by Rahul Ramachandran on 14/09/24.
//

import SwiftUI
import UIKit

// Wrapper for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage? // Bind the selected image to the SwiftUI view

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Handle the selected image and dismiss the picker
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    // Create the coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Set up the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    // Not needed in this case but dummy function needed to conform to protocol
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
