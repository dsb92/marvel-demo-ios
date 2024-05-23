struct CharacterServiceWithFallback: CharacterServiceSchema {
    let primary: CharacterServiceSchema
    let fallback: CharacterServiceSchema
    
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper? {
        let characters = try await primary.getCharacters(parameters: parameters)
        guard let characters, let data = characters.data, let results = data.results, !results.isEmpty else {
            return try await fallback.getCharacters(parameters: parameters)
        }
        return characters
    }
}

extension CharacterServiceSchema {
    func fallback(_ fallback: CharacterServiceSchema) -> CharacterServiceSchema {
        CharacterServiceWithFallback(primary: self, fallback: fallback)
    }
}
