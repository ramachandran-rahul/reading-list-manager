# PageKeeper App

## Overview
PageKeeper is an iOS app that helps users manage and track their reading progress. It allows users to add books, update reading progress, and mark favourites, all within a clean and user-friendly interface. Users can upload custom cover images and track their reading habits with progress tracking and completion indicators.

## Features
- **Add Books**: Enter book details (title, author, genre, total pages) and upload a cover image.
- **Track Progress**: Update the number of pages read, and see progress as a percentage.
- **Favourites**: Mark books as favourites for easy access, and view them in a separate section.
- **Filter by Genre**: Quickly filter books by genre, making it easier to track your books.
- **Completion Status**: Completed books are highlighted with a green progress bar and a checkmark.
- **Image Upload**: Users can upload book cover images from their device's photo gallery.

## Technical Overview
- **SwiftUI & MVVM**: Built using SwiftUI for modern, reactive UI design, following the MVVM (Model-View-ViewModel) architecture for clear separation of concerns.
- **Data Persistence**:
  - **UserDefaults**: Stores book details (title, author, genre, pages read, etc.).
  - **Documents Directory**: Saves book cover images locally, with the image path stored in UserDefaults.
- **State Management**: Utilises `@StateObject`, `@Binding`, and `@Published` for seamless state updates across views.
- **Custom Protocol**: Implements a protocol to streamline and standardize the handling of "favourite" functionality and its toggling across objects, improving code consistency and reuse.
- **ImagePicker**: A custom ImagePicker view integrates `UIImagePickerController` to allow image selection from the user's device.
- **Error Handling**: Input validation ensures users provide valid book data, with error alerts displayed when needed.

## Future Improvements
- **Core Data**: Migrate from UserDefaults to Core Data for better data handling and scalability.
- **Cloud Sync**: Add cloud synchronization (e.g., iCloud) to sync books and progress across multiple devices.
- **Search Functionality**: Implement a search feature to help users find books by title or author.

## License
PageKeeper is available under the MIT License.

## GitHub
[https://github.com/yourusername/PageKeeper.git](https://github.com/ramachandran-rahul/reading-list-manager)
