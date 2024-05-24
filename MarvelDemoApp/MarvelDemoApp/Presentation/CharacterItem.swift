import Foundation
import SwiftUI

struct CharacterItem {
    let id = UUID()
    let url: String
    let name: String
    let description: String
    let itemLists: [ItemList]
}
