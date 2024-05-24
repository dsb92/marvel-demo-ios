import SwiftUI

struct CharactersScreen: View {
    let characterItemList: CharacterItemList

    var body: some View {
        CharactersView(characterItemList: characterItemList)
    }
}
