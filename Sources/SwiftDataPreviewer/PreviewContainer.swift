//
// Project: SwiftDataPreviewer
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import SwiftUI
import SwiftData
import SimpleLogger

/// A container for managing SwiftData models in a preview environment.
///
/// This structure provides an in-memory `ModelContainer` for use in SwiftUI previews. It allows
/// inserting persistent models for testing and debugging.
///
/// - Important: This struct is only available in `DEBUG` builds.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, macCatalyst 17.0, *)
public struct PreviewContainer {

    /// The SwiftData `ModelContainer` used for storing models.
    internal let container: ModelContainer!

    /// A logger instance for logging SwiftData-related messages.
    private let logger = SimpleLogger(category: .swiftData)

    /// Creates a new `PreviewContainer` instance.
    ///
    /// - Parameters:
    ///   - types: An array of `PersistentModel` types to include in the schema.
    ///   - isStoredInMemoryOnly: A Boolean indicating whether the container should use in-memory
    ///   storage. Default is `true`.
    public init(
        _ types: [any PersistentModel.Type],
        isStoredInMemoryOnly: Bool = true
    ) {
        let schema = Schema(types)
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )

        do {
            self.container = try ModelContainer(
                for: schema,
                configurations: configuration
            )
            self.logger.info("ModelContainer successfully initialized")
        } catch {
            self.container = nil
            self.logger.error("ModelContainer failed to initialize: \(error, privacy: .public)")
            fatalError("ERROR: ModelContainer failed to initialize")
        }
    }

    /// Inserts an array of `PersistentModel` items into the preview container.
    ///
    /// - Parameter items: An array of `PersistentModel` instances to add to the main context.
    internal func add(items: [any PersistentModel]) {
        DispatchQueue.main.sync {
            items.forEach { container.mainContext.insert($0) }
        }
    }
}

#endif
