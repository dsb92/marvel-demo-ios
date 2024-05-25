import SwiftUI

struct ItemDetailView: View {
    let itemViewModel: ItemViewModel
    
    var body: some View {
        VStack {
            ItemView(itemViewModel: itemViewModel)
            ForEach(itemViewModel.itemLists, id: \.id) { itemList in
                ItemListsView(title: itemList.title, color: itemList.color, items: itemList.items)
            }
        }
    }
}

struct ItemListDetailView<ViewModel>: View where ViewModel: ItemListDetailViewModelSchema {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ItemDetailView(itemViewModel: viewModel.itemViewModel)
    }
}

#Preview {
    ItemListDetailView(viewModel: ItemListDetailViewModel(itemViewModel: .mock()))
}
