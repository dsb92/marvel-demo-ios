import Foundation

struct MockThrowErrorCharacterAPIService: CharacterServiceSchema {
    func getCharacters(
        parameters: CharacterGetParameters
    ) async throws -> CharacterDataWrapper {
        throw URLError(.badURL)
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) {}
}
