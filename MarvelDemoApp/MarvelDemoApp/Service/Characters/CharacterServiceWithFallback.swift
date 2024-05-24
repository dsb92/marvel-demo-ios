struct CharacterServiceWithFallback: CharacterServiceSchema {
    let primary: CharacterServiceSchema
    let fallback: CharacterServiceSchema
    
    func getCharacters(parameters: CharacterGetParameters) async throws -> CharacterDataWrapper {
        do {
            let primaryCharacters = try await primary.getCharacters(parameters: parameters)
            fallback.saveCharacters(primaryCharacters)
            return primaryCharacters
        } catch {
            let fallbackCharacters = try await fallback.getCharacters(parameters: parameters)
            primary.saveCharacters(fallbackCharacters)
            return fallbackCharacters
        }
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) {}
}

extension CharacterServiceSchema {
    func fallback(_ fallback: CharacterServiceSchema) -> CharacterServiceSchema {
        CharacterServiceWithFallback(primary: self, fallback: fallback)
    }
}
