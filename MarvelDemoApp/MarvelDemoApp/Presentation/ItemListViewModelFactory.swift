protocol ItemListViewModelFactorySchema {
    func createDetailViewModel(for itemViewModel: ItemViewModel) -> ItemListDetailViewModel
}

struct ItemListViewModelFactory: ItemListViewModelFactorySchema {
    func createDetailViewModel(for itemViewModel: ItemViewModel) -> ItemListDetailViewModel {
        ItemListDetailViewModel(itemViewModel: itemViewModel)
    }
}
