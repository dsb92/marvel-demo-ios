import SwiftUI

struct ItemListView: View {
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
    let url: String

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
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

extension CharactersView {
    struct CharacterThumbnail: View {
        let url: String
        
        var body: some View {
            Thumbnail(url: url)
        }
    }
}

extension CharactersView {
    struct CharacterItems: View {
        let title: String
        let color: Color
        let items: [Item]
        
        var body: some View {
            ItemListView(title: title, color: color, items: items)
        }
    }
}

extension CharactersView {
    struct CharacterView: View {
        let character: CharacterItem
        
        var body: some View {
            LazyVStack {
                CharacterThumbnail(url: character.url)
                Text(character.name)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                Text(character.description)
                    .font(.title2)
                ForEach(character.itemLists, id: \.id) { itemList in
                    CharacterItems(title: itemList.title, color: itemList.color, items: itemList.items)
                }
            }
        }
    }
}

struct CharactersView: View {
    let characterItemList: CharacterItemList
    
    var body: some View {
        ScrollView {
            ForEach(characterItemList.characters, id: \.id) { character in
                CharacterView(character: character)
            }
        }
    }
}

private extension Array where Element == CharacterItem {
    static func mock() -> Self {
        [
            CharacterItem(
                url: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg",
                name: "3-D Man",
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

#Preview {
    CharactersView(characterItemList: .init(characters: .mock()))
}
