<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SwiftDataPreviewer

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSwiftDataPreviewer%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSwiftDataPreviewer%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`SwiftDataPreviewer` is a lightweight Swift package designed to simplify SwiftUI previews using SwiftData. It provides an **in-memory model container** for use in `DEBUG` builds, allowing you to preview your SwiftData-powered views with sample data.

## Features

- **Seamless SwiftData Previews**: Easily inject a `ModelContainer` into your SwiftUI previews.
- **In-Memory Storage**: Prevents persistent data pollution while testing.
- **Automatic Sample Data Insertion**: Quickly preview lists and other data-driven views.
- **Developer-Friendly API**: Just wrap your view with `SwiftDataPreviewer`.

## Installation

Add `SwiftDataPreviewer` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/SwiftDataPreviewer", from: "1.0.0")
]
```

Alternatively, you can add `SwiftDataPreviewer` using Xcode by navigating to `File > Add Packages` and entering the package repository URL.

## Recommended Usage

> [!NOTE]
> `SwiftDataPreviewer` is designed for SwiftUI previews only and is not meant for production usage. It provides an in-memory `ModelContainer` that is automatically configured for SwiftData-powered views.

## Usage

1. Define a SwiftData Model

   Ensure your SwiftData model conforms to PersistentModel:

    ```swift
    import SwiftData

    @Model
    final class Item {
      var timestamp: Date 

      init(timestamp: Date) {
        self.timestamp = timestamp
      }
    }
    ```

2. Create a Preview Container (optional)

   Define a `PreviewContainer` with the model types you want to include:

    ```swift
    #if DEBUG
    import SwiftDataPreviewer

    final class Previewer {
      let previewContainer = PreviewContainer(Item.self)
    }
    #endif
    ```

3. Use `SwiftDataPreviewer` in Your Previews

   Wrap your SwiftUI view in `SwiftDataPreviewer` and pass sample data:

    ```swift
    #if DEBUG
    import SwiftUI
    import SwiftData

    struct ItemListView: View {
      @Query private var items: [Item]

      var body: some View {
        List(items) { item in
          Text(item.timestamp, style: .date)
        }
      }
    }

    // Pre-Xcode 15
    struct UserListView_Previews: PreviewProvider {
      static var previews: some View {
        SwiftDataPreviewer(
          preview: Previewer.previewContainer,
          items: [
            Item(timestamp: Date()),
            Item(timestamp: Date()),
            Item(timestamp: Date()),
          ]
        ) {
          ItemListView()
        }
      }
    }

    // Post-Xcode 15
    #Preview("Array items") {
      SwiftDataPreviewer(
        preview: PreviewContainer(Item.self),
        items: Item.mockItems
      ) {
        ItemListView()
      }
    }

    #Preview("Single item") {
      SwiftDataPreviewer(
        preview: Previewer.previewContainer,
        item: Item.mockItem
      ) {
        ContentView()
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

`SwiftDataPreviewer` is available under the MIT licence. See the LICENCE file for more details.
