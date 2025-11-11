//
// Project: SwiftDataPreviewerExample
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SwiftData
import SwiftDataPreviewer

// MARK: - Preview

/// A SwiftUI preview that uses an in-memory SwiftData container populated with multiple mock items.
///
/// This preview creates a temporary `ModelContainer` for the `Item` model type using
/// `PreviewContainer`, inserts an array of mock `Item` instances from `Item.mockItems`, and renders
/// `ContentView` as if it were running with a live SwiftData store.
#Preview("Array items") {
    SwiftDataPreviewer(
        preview: PreviewContainer(Item.self),
        items: Item.mockItems
    ) {
        ContentView()
    }
}

/// A helper type providing shared preview resources for SwiftData previews.
///
/// This allows reuse of a single in-memory `PreviewContainer` across multiple previews, improving
/// consistency and avoiding redundant container initialization.
private final class Preview {
    static let previewContainer = PreviewContainer(Item.self)
}

/// A SwiftUI preview that uses an in-memory SwiftData container populated with a single mock item.
///
/// This preview reuses the shared `PreviewContainer` from `Preview` and inserts one example
/// `Item` from `Item.mockItem` before rendering `ContentView`. Use this preview to focus on
/// layout and behaviour with a single data record.
#Preview("Single item") {
    SwiftDataPreviewer(
        preview: Preview.previewContainer,
        item: Item.mockItem
    ) {
        ContentView()
    }
}

// MARK: - SwiftData Model

/// A simple SwiftData model representing a timestamped item.
///
/// The `Item` model stores a `Date` value and is used to demonstrate how
/// to query and display SwiftData models in SwiftUI previews.
@Model
final class Item {

    /// The timestamp associated with the item.
    var timestamp: Date

    /// Creates a new `Item` with a given timestamp.
    ///
    /// - Parameter timestamp: The date and time to assign to the item.
    init(timestamp: Date) {
        self.timestamp = timestamp
    }

    /// A predefined list of mock items for use in previews.
    ///
    /// This provides several items with different timestamps for realistic sample data.
    static let mockItems: [Item] = [
        Item(timestamp: Date()),
        Item(timestamp: Date(timeIntervalSinceNow: -3600)),   // 1 hour ago
        Item(timestamp: Date(timeIntervalSinceNow: -86400)),  // 1 day ago
        Item(timestamp: Date(timeIntervalSinceNow: 3600)),    // 1 hour ahead
        Item(timestamp: Date(timeIntervalSince1970: 1700000000)) // fixed date
    ]

    /// A single mock item for convenience in simple previews.
    static let mockItem: Item = .mockItems.first!
}

// MARK: - View

/// The main content view that displays a list of stored `Item` objects.
///
/// The view uses a SwiftData `@Query` property wrapper to automatically fetch and observe changes
/// to `Item` instances in the current model context.
struct ContentView: View {

    /// The list of `Item` objects fetched from SwiftData.
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            List(items) { item in
                Text(item.timestamp, style: .date)
            }
            .navigationTitle("Items")
        }
    }
}

// MARK: - Example App

/// The main entry point for the SwiftData preview example app.
///
/// This app demonstrates how to use `SwiftDataPreviewer` and `PreviewContainer`
/// to preview a SwiftUI view that uses SwiftData without requiring a full persistent store.
@main
struct SwiftDataPreviewerExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self, inMemory: true)
    }
}
