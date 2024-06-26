import Foundation
import SwiftUI
import OSLog

extension ItemViewModel {
    init(from character: ´Character´) {
        self.id = character.id
        if let thumbnail = character.thumbnail, let path = thumbnail.path, let thumbnailExtension = thumbnail.thumbnailExtension {
            self.url = URL(string: "\(path).\(thumbnailExtension)")
        }
        if let description = character.description {
            self.description = description
        }
        if let name = character.name {
            self.title = name
        }
        if let description = character.description {
            self.subtitle = description
        }
        var itemLists = [ItemList]()
        if let comics = character.comics, let items = comics.items {
            itemLists.append(
                createItemList(title: "Comics", color: .green, from: items)
            )
        }
        if let stories = character.stories, let items = stories.items {
            itemLists.append(
                createItemList(title: "Stories", color: .yellow, from: items)
            )
        }
        if let series = character.series, let items = series.items {
            itemLists.append(
                createItemList(title: "Series", color: .brown, from: items)
            )
        }
        if let events = character.events, let items = events.items {
            itemLists.append(
                createItemList(title: "Events", color: .red, from: items)
            )
        }
        self.itemLists = itemLists
    }
    
    func createItemList<T: Nameable>(title: String, color: Color, from items: [T]) -> ItemList {
        let filteredItems = items.compactMap { $0.name }.map { Item(name: $0) }
        return ItemList(title: title, color: color, items: filteredItems)
    }
}

struct ItemViewModel: Identifiable {
    var id: Int?
    var url: URL?
    var title: String = ""
    var description: String = ""
    var subtitle: String = ""
    var itemLists: [ItemList] = []
}

@MainActor
protocol ItemListViewModelSchema: ObservableObject {
    var itemViewModels: [ItemViewModel] { get set }
    var viewState: ViewState { get set }
    var error: Swift.Error? { get set }
    func send(_ action: ItemListViewModelAction)
}

enum ItemListViewModelAction {
    case loadItems
}

enum ItemListViewScreens {
    case detail(ItemViewModel)
}

@MainActor
final class ItemListViewModel: ItemListViewModelSchema {
    @Published var itemViewModels: [ItemViewModel] = []
    @Published var viewState: ViewState = .idle
    @Published var error: Swift.Error?
    
    private var itemService: ItemsServiceSchema
    init(itemService: ItemsServiceSchema) {
        self.itemService = itemService
    }

    func send(_ action: ItemListViewModelAction) {
        switch action {
        case .loadItems:
            Task {
                await loadItems()
            }
        }
    }

    private func loadItems() async {
        do {
            if itemViewModels.isEmpty {
                viewState = .loading
            }
            itemViewModels = try await itemService.loadItems()
            if itemViewModels.isEmpty {
                viewState = .empty
            } else {
                viewState = .loaded
            }
        } catch {
            viewState = .failed
            self.error = error
        }
    }
}

enum ViewState {
    case loading
    case failed
    case loaded
    case empty
    case idle
}
