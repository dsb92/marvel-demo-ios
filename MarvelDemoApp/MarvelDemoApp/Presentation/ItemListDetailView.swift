import SwiftUI

struct ItemListsView: View {
    let title: String
    let color: Color
    let items: [Item]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.id) { item in
                        Text(item.name)
                            .padding()
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.gray)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
            }
        }
    }
}

struct ItemDetailView: View {
    let itemViewModel: ItemViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack {
                    ItemView(itemViewModel: itemViewModel)
                    Text(itemViewModel.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding()
                    ForEach(itemViewModel.itemLists, id: \.id) { itemList in
                        ItemListsView(title: itemList.title, color: itemList.color, items: itemList.items)
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
            }
            BackButton()
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .top)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        }
        .padding(30)
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
