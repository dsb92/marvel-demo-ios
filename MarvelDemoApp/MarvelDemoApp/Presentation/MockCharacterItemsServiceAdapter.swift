import Foundation
import SwiftUI

struct MockCharacterItemsServiceAdapter: ItemsServiceSchema {
    let service: CharacterServiceSchema
    
    func loadItems() async throws -> [ItemViewModel] {
        [
            ItemViewModel(id: 0, url: URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"), title: "3-D Man", description: "", subtitle: "", itemLists: .mock())
        ]
    }
}

private extension Array where Element == ItemViewModel {
    static func mock() -> Self {
        [
            ItemViewModel(
                id: 0,
                url: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"),
                title: "3-D Man",
                description: "",
                itemLists: .mock()
            )
        ]
    }
}

private extension Array where Element == ItemList {
    static func mock() -> Self {
        [
            ItemList(title: "Comics", color: .green, items: .mock(color: .green)),
            ItemList(title: "Series", color: .blue, items: .mock(color: .blue)),
            ItemList(title: "Stories", color: .brown, items: .mock(color: .brown)),
            ItemList(title: "Events", color: .red, items: .mock(color: .red))
        ]
    }
}

private extension Array where Element == Item {
    static func mock(color: Color) -> Self {
        [
            Item(name: "Avengers: The Initiative (2007) #14")
        ]
    }
}
