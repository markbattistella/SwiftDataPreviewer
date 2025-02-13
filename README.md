<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SwiftDataPreviewKit

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyourusername%2FSwiftDataPreviewKit%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyourusername%2FSwiftDataPreviewKit%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`SwiftDataPreviewKit` is a lightweight Swift package designed to simplify SwiftUI previews using SwiftData. It provides an **in-memory model container** for use in `DEBUG` builds, allowing you to preview your SwiftData-powered views with sample data.

## Features

- **Seamless SwiftData Previews**: Easily inject a `ModelContainer` into your SwiftUI previews.
- **In-Memory Storage**: Prevents persistent data pollution while testing.
- **Automatic Sample Data Insertion**: Quickly preview lists and other data-driven views.
- **Developer-Friendly API**: Just wrap your view with `SwiftDataPreviewer`.

## Installation

Add `SwiftDataPreviewKit` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/SwiftDataPreviewKit", from: "1.0.0")
]
```

Alternatively, you can add `SwiftDataPreviewKit` using Xcode by navigating to `File > Add Packages` and entering the package repository URL.

## Recommended Usage

> [!NOTE]
> `SwiftDataPreviewKit` is designed for SwiftUI previews only and is not meant for production usage. It provides an in-memory `ModelContainer` that is automatically configured for SwiftData-powered views.

## Usage

1. Define a SwiftData Model

   Ensure your SwiftData model conforms to PersistentModel:

   ```swift
   import SwiftData

   @Model
   class User {
     @Attribute(.unique) var id: UUID
     var name: String

     init(id: UUID = UUID(), name: String) {
       self.id = id
       self.name = name
     }
   }
   ```

2. Create a Preview Container

   Define a PreviewContainer with the model types you want to include:

   ```swift
   #if DEBUG
   import SwiftDataPreviewKit

   let previewContainer = PreviewContainer([User.self])
   #endif
   ```

3. Use `SwiftDataPreviewer` in Your Previews

   Wrap your SwiftUI view in `SwiftDataPreviewer` and pass sample data:

   ```swift
   #if DEBUG
   import SwiftUI
   import SwiftData

   struct UserListView: View {
     @Query private var users: [User]

     var body: some View {
       List(users) { user in
         Text(user.name)
       }
     }
   }

   struct UserListView_Previews: PreviewProvider {
     static var previews: some View {
       SwiftDataPreviewer(preview: previewContainer, items: [
         User(name: "Alice"),
         User(name: "Bob"),
         User(name: "Charlie")
       ]) {
         UserListView()
       }
     }
   }
   #endif
   ```

## How It Works

1. PreviewContainer creates an in-memory ModelContainer.

1. SwiftDataPreviewer injects the container into your SwiftUI view.

1. Sample data is automatically inserted so your previews are populated.

## Contributing

Contributions are welcome! If you find a bug or have suggestions for improvements, feel free to submit a pull request.

## Licence

`SwiftDataPreviewKit` is available under the MIT licence. See the LICENCE file for more details.
