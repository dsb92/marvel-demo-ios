import SwiftUI

struct ItemListsView: View {
    let title: String
    let color: Color
    let items: [Item]
    
    var body: some View {
        Text(title)
            .font(.title)
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundStyle(.white)
        ScrollView(.horizontal) {
            HStack {
                ForEach(items, id: \.id) { item in
                    Text(item.name)
                        .padding()
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(color)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 25))
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 40)
    }
}

struct Thumbnail: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
              case .failure:
                  Image(systemName: "photo")
                      .font(.largeTitle)
              case .success(let image):
                  image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(height: 300)
                      .clipShape(.rect(cornerRadius: 25))
              default:
                  ProgressView()
              }
        }
    }
}

struct ItemView: View {
    let itemViewModel: ItemViewModel
    
    var body: some View {
        VStack {
            Thumbnail(url: itemViewModel.url)
            Text(itemViewModel.title)
                .font(.title)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
            Text(itemViewModel.description)
                .font(.title2)
            ForEach(itemViewModel.itemLists, id: \.id) { itemList in
                ItemListsView(title: itemList.title, color: itemList.color, items: itemList.items)
            }
        }
    }
}

struct ItemListView<ViewModel>: View where ViewModel: ItemListViewModelSchema {
    @StateObject private var viewModel: ViewModel
    var viewModelFactory: ItemListViewModelFactorySchema
    
    init(viewModel: @autoclosure @escaping () -> ViewModel, viewModelFactory: ItemListViewModelFactory) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self.viewModelFactory = viewModelFactory
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.itemViewModels, id: \.id) { itemViewModel in
                    NavigationLink {
                        ItemListDetailView(viewModel: viewModelFactory.createDetailViewModel(for: itemViewModel.wrappedValue))
                    } label: {
                        ItemView(itemViewModel: itemViewModel.wrappedValue)
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.send(.loadItems)
            }
            .onAppear {
                viewModel.send(.loadItems)
            }
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(itemService: MockItemsServiceFactory().createItemsService()), viewModelFactory: ItemListViewModelFactory())
}
