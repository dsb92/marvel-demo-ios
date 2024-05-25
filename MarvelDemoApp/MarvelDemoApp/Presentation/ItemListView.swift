import SwiftUI

struct Thumbnail: View {
    let url: URL?

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                AsyncImage(url: url, transaction: Transaction(animation: .default)) { phase in
                    switch phase {
                      case .failure:
                          Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                      case .success(let image):
                          image
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                      default:
                          ProgressView()
                      }
                }
                .ignoresSafeArea()
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            }
        }
    }
}

struct ItemView: View {
    let itemViewModel: ItemViewModel

    var body: some View {
        ZStack {
            Thumbnail(url: itemViewModel.url)
            VStack {
                Text(itemViewModel.title.uppercased())
                    .bold()
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                    .padding()
            }
            .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
}

struct CardView: View {
    let itemViewModel: ItemViewModel
    
    var body: some View {
        ItemView(itemViewModel: itemViewModel)
            .clipShape(.rect(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black)
                    .shadow(radius: 1)
            )
            .padding([.top, .horizontal])
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
                    ZStack {
                        CardView(itemViewModel: itemViewModel.wrappedValue)
                        NavigationLink(destination: ItemListDetailView(viewModel: viewModelFactory.createDetailViewModel(for: itemViewModel.wrappedValue))
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                        .buttonStyle(.plain)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
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
