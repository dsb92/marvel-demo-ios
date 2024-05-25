import SwiftUI

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
                      .clipped()
              default:
                  ProgressView()
              }
        }
    }
}

struct ItemView: View {
    let itemViewModel: ItemViewModel

    var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Thumbnail(url: itemViewModel.url)
                
                VStack {
                    Spacer()
                    HStack {
                        Text(itemViewModel.title.uppercased())
                            .bold()
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
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
                            .transition(.moveAndFade)
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


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing).combined(with: .opacity)
    }
}
