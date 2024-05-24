struct MockFallbackCharacterService: CharacterServiceSchema {
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper? {
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
                results: [
                    ´Character´(
                        id: 1,
                        name: "Fallback Character",
                        description: "A fallback character",
                        modified: nil,
                        resourceURI: nil,
                        urls: nil,
                        thumbnail: nil,
                        comics: nil,
                        stories: nil,
                        events: nil,
                        series: nil
                    )
                ]
            ),
            etag: nil
        )
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper?) {}
}
