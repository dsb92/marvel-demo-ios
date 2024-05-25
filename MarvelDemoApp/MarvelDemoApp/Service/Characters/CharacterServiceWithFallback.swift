struct CharacterServiceWithFallback: CharacterServiceSchema {
    let primary: CharacterServiceSchema
    let fallback: CharacterServiceSchema
    
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper {
        do {
            let primaryCharacters = try await primary.getCharacters(parameters: parameters)
            try await fallback.saveCharacters(primaryCharacters)
            return primaryCharacters
        } catch {
            let fallbackCharacters = try await fallback.getCharacters(parameters: parameters)
            try await primary.saveCharacters(fallbackCharacters)
            return fallbackCharacters
        }
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) async throws {}
}

extension CharacterServiceSchema {
    func fallback(_ fallback: CharacterServiceSchema) -> CharacterServiceSchema {
        CharacterServiceWithFallback(primary: self, fallback: fallback)
    }
}
