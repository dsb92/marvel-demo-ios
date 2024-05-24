import Foundation

struct MockCharacterServiceFactory: CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema {
        let apiClient = MockAPIClientFactory().createAPIClient()
        let apiParser = SimpleJSONParser(jsonDecoder: JSONDecoder())
        let primary = MockCharacterAPIService()
        let fallback = CharacterStorageService(storage: CharactersCoreDataManager.shared)
        return primary.fallback(fallback)
    }
}
