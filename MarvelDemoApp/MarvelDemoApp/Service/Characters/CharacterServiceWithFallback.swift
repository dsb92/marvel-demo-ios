import Foundation

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
            if let characters = fallbackCharacters.data?.results, characters.isEmpty {
                throw FallbackError.networkErrorFallbackEmpty(error)
            }
            try await primary.saveCharacters(fallbackCharacters)
            return fallbackCharacters
        }
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) async throws {}
}

enum FallbackError: Error, LocalizedError {
    case networkErrorFallbackEmpty(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkErrorFallbackEmpty(let error):
            return "Was not able to load from network and storage is empty...network error is: \(error)"
        }
    }
}

extension CharacterServiceSchema {
    func fallback(_ fallback: CharacterServiceSchema) -> CharacterServiceSchema {
        CharacterServiceWithFallback(primary: self, fallback: fallback)
    }
}
