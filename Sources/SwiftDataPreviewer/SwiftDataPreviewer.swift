//
// Project: SwiftDataPreviewer
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import SwiftData
import SwiftUI

/// A utility view that provides a SwiftData `ModelContainer` for SwiftUI previews.
///
/// `SwiftDataPreviewer` enables SwiftUI preview rendering with a preconfigured in-memory
/// `ModelContainer` supplied by a `PreviewContainer`. It optionally inserts mock data for use in
/// your preview content.
///
/// Example usage:
/// ```swift
/// #if DEBUG
/// struct UserListView_Previews: PreviewProvider {
///     static var previews: some View {
///         SwiftDataPreviewer(
///             preview: PreviewContainer([User.self]),
///             items: [User(name: "Alice"), User(name: "Bob")]
///         ) {
///             UserListView()
///         }
///     }
/// }
/// #endif
/// ```
public struct SwiftDataPreviewer<Content: View>: View {

    /// The preview `ModelContainer` used to supply the SwiftData context.
    private let preview: PreviewContainer

    /// Optional mock data to insert into the preview container.
    private let items: [any PersistentModel]?

    /// The SwiftUI content view that uses the provided model container.
    private let content: Content

    /// Creates a SwiftUI preview environment with a temporary SwiftData container and optional
    /// mock data.
    ///
    /// Use this initializer when you want to insert multiple mock model objects into the
    /// preview container before rendering the view.
    ///
    /// - Parameters:
    ///   - preview: A `PreviewContainer` that provides the in-memory `ModelContainer`.
    ///   - items: Optional array of mock model objects to insert into the container.
    ///   - content: A view builder closure returning the SwiftUI content to preview.
    ///
    /// Example:
    /// ```swift
    /// SwiftDataPreviewer(
    ///     preview: PreviewContainer([Item.self]),
    ///     items: Item.mockItems
    /// ) {
    ///     ContentView()
    /// }
    /// ```
    public init(
        preview: PreviewContainer,
        items: [any PersistentModel]? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.preview = preview
        self.items = items
        if let items = items {
            preview.add(items: items)
        }
        self.content = content()
    }

    /// Convenience initializer for inserting a single mock model object into the preview container.
    ///
    /// Use this variant when you only need to preview a view with one example model instance.
    ///
    /// - Parameters:
    ///   - preview: A `PreviewContainer` that provides the in-memory `ModelContainer`.
    ///   - item: An optional single mock model object to insert into the preview container.
    ///   - content: A view builder closure returning the SwiftUI content to preview.
    ///
    /// Example:
    /// ```swift
    /// SwiftDataPreviewer(
    ///     preview: PreviewContainer([User.self]),
    ///     item: User(name: "Preview User")
    /// ) {
    ///     UserDetailView()
    /// }
    /// ```
    public init(
        preview: PreviewContainer,
        item: (any PersistentModel)? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        if let item = item {
            self.init(preview: preview, items: [item], content)
        } else {
            self.init(preview: preview, items: nil, content)
        }
    }

    /// The body of the view that injects the model container into the SwiftUI environment.
    public var body: some View {
        content.modelContainer(preview.container)
    }
}

#endif
