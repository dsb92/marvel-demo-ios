import SwiftUI

@main
struct MarvelDemoApp: App {
    @StateObject var viewModel = ItemListViewModel(itemService: ItemsServiceFactory().createItemsService())
    
    var body: some Scene {
        WindowGroup {
            ItemListView(viewModel: viewModel)
        }
    }
}
