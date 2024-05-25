import Foundation
import SwiftUI
import OSLog

protocol ItemListDetailViewModelSchema: ObservableObject {
    var itemViewModel: ItemViewModel { get set }
}

final class ItemListDetailViewModel: ItemListDetailViewModelSchema {
    @Published var itemViewModel: ItemViewModel
    
    init(itemViewModel: ItemViewModel) {
        self.itemViewModel = itemViewModel
    }
}
