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
            LazyHStack {
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
        LazyVStack {
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

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            ForEach($viewModel.itemViewModel, id: \.id) { itemViewModel in
                ItemView(itemViewModel: itemViewModel.wrappedValue)
            }
        }
        .task {
            await viewModel.loadItems()
        }
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

//#Preview {
//    ItemListView(itemListViewModel: .init(itemService: <#T##ItemService#>)))
//}
