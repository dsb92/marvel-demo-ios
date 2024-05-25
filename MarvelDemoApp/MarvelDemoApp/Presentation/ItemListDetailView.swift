import SwiftUI

struct ItemListDetailView<ViewModel>: View where ViewModel: ItemListDetailViewModelSchema {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Text("Hello World")
    }
}
