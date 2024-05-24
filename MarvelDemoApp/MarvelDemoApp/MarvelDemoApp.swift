import SwiftUI

@main
struct MarvelDemoApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersScreen(characterItemList: .init(characters: []))
        }
    }
}
