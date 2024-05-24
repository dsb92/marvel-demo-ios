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

#Preview {
    ItemListView(viewModel: ItemListViewModel(itemService: MockItemsServiceFactory().createItemsService()))
}
