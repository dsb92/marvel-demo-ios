struct MockCharacterServiceAPI: CharacterServiceSchema {
    private let JSON_FILE_NAME = "CharacterDataWrapper.json"
    
    func getCharacters(
        parameters: CharacterGetParameters
    ) async throws -> CharacterDataWrapper {
        load(JSON_FILE_NAME)
    }
    
    func saveCharacters(_ characters: CharacterDataWrapper) {}
}
