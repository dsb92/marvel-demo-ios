protocol ItemsService {
    func loadItems() async throws -> [ItemViewModel]
}

struct CharacterItemsServiceAdapter: ItemsService {
    let service: CharacterServiceSchema
    
    func loadItems() async throws -> [ItemViewModel] {
        let characters = try await service.getCharacters(parameters: .init())
        return characters?.data?.results?.compactMap { character in
            ItemViewModel(from: character)
        } ?? []
    }
}
