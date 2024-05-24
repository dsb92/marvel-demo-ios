struct CharacterStorageService: CharacterServiceSchema {
    let storage: CharactersStorageSchema
    
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper? {
        let characters = storage.fetchAll()
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
    
    func saveCharacters(_ characters: CharacterDataWrapper?) {
        guard let wrapper = characters, let results = wrapper.data?.results else { return }
        storage.save(characters: results)
    }
}
