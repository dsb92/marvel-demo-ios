struct CharacterStorageService: CharacterServiceSchema {
    let storage: CharactersStorageSchema
    
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper {
        let characters = try await storage.fetchAll()
        return CharacterDataWrapper(
            code: nil,
            status: nil,
            copyright: nil,
            attributionText: nil,
            attributionHTML: nil,
            data: CharacterDataContainer(
                offset: nil,
                limit: nil,
                total: nil,
                count: nil,
                results: characters
            ),
            etag: nil
        )
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) async throws {
        guard let results = characters.data?.results else { return }
        try await storage.save(characters: results)
    }
}
