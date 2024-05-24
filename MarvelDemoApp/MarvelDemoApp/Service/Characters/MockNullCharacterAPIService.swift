struct MockNullCharacterAPIService: CharacterServiceSchema {
    func getCharacters(
        parameters: CharacterGetParameters
    ) async throws -> CharacterDataWrapper? {
        nil
    }
}
