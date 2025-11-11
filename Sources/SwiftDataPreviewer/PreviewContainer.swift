//
// Project: SwiftDataPreviewer
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import SwiftUI
import SwiftData
import SimpleLogger

/// A helper structure used to create an in-memory `ModelContainer` for SwiftData previews and
/// testing.
///
/// `PreviewContainer` simplifies setting up a temporary persistence container so you can easily
/// preview SwiftUI views with sample data during development. This container should only be used
/// within debug builds.
///
/// Example usage:
/// ```swift
/// #if DEBUG
/// let preview = PreviewContainer([User.self])
/// #endif
/// ```
public struct PreviewContainer {

    /// The underlying `ModelContainer` instance used for storing model data in memory.
    ///
    /// - Note: This is internal and should not be directly accessed outside the preview context.
    internal let container: ModelContainer!

    /// A logger instance for logging SwiftData-related messages.
    private let logger = SimpleLogger(category: .swiftData)

    /// Creates a new in-memory SwiftData container for use in SwiftUI previews or tests.
    ///
    /// - Parameters:
    ///   - types: An array of model types conforming to `PersistentModel` that define the schema.
    ///   - isStoredInMemoryOnly: A Boolean value indicating whether data should be stored only in
    ///   memory. Defaults to `true` to avoid writing to disk.
    ///
    /// If the container fails to initialise, the app will terminate with a `fatalError`.
    public init(
        _ types: any PersistentModel.Type...,
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

    /// Inserts the given mock model objects into the preview container’s main context.
    ///
    /// - Parameter items: An array of models conforming to `PersistentModel` to insert into the
    /// container.
    @MainActor
    internal func add(items: [any PersistentModel]) {
        items.forEach {
            container.mainContext.insert($0)
        }
    }
}

#endif
