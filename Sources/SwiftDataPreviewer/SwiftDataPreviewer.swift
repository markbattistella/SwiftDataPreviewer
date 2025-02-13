//
// Project: SwiftDataPreviewer
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import SwiftUI
import SwiftData

/// A SwiftUI view that provides a preview environment for SwiftData models.
///
/// This view wraps content in a `modelContainer` configured for SwiftUI previews. It allows
/// injecting a `PreviewContainer` and optionally inserting sample data.
///
/// - Parameters:
///   - Content: The SwiftUI view type displayed inside the preview.
///
/// - Important: This struct is only available in `DEBUG` builds.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, macCatalyst 17.0, *)
public struct SwiftDataPreviewer<Content: View>: View {

    /// The `PreviewContainer` managing the SwiftData models.
    private let preview: PreviewContainer

    /// The array of `PersistentModel` items to be added to the preview.
    private let items: [any PersistentModel]?

    /// The SwiftUI content view displayed inside the preview.
    private let content: Content

    /// Creates a new `SwiftDataPreviewer` instance.
    ///
    /// - Parameters:
    ///   - preview: A `PreviewContainer` providing an in-memory model container.
    ///   - items: An optional array of `PersistentModel` instances to insert into the preview.
    ///   - content: A view builder closure returning the SwiftUI content to be previewed.
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

    /// The body of the `SwiftDataPreviewer`, embedding the content inside a `modelContainer`.
    public var body: some View {
        content.modelContainer(preview.container)
    }
}

#endif
