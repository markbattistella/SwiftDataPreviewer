//
// Project: SwiftDataPreviewer
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

  import SwiftData
  import Foundation
  import Testing
  @testable import SwiftDataPreviewer

  @Model
  final class PreviewItem {

    /// The display name used for fetch verification.
    var name: String

    init(name: String) {
      self.name = name
    }
  }

  @Suite("PreviewContainer")
  @MainActor
  struct PreviewContainerTests {

    @Test("Creates an in-memory container")
    func createsInMemoryContainer() throws {
      let preview = PreviewContainer(PreviewItem.self)
      let descriptor = FetchDescriptor<PreviewItem>()

      let items = try preview.container.mainContext.fetch(descriptor)

      #expect(items.isEmpty)
    }

    @Test("Adds preview items and saves them")
    func addsPreviewItemsAndSavesThem() throws {
      let preview = PreviewContainer(PreviewItem.self)

      preview.add(items: [
        PreviewItem(name: "One"),
        PreviewItem(name: "Two"),
      ])

      var descriptor = FetchDescriptor<PreviewItem>(
        sortBy: [SortDescriptor<PreviewItem>(\.name)]
      )
      descriptor.fetchLimit = 10

      let items = try preview.container.mainContext.fetch(descriptor)

      #expect(items.map(\.name) == ["One", "Two"])
    }
  }

#endif
