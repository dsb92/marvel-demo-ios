import Foundation

struct MockCharacterServiceFactory: CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema {
        let apiClient = MockAPIClientFactory().createAPIClient()
        let apiParser = SimpleJSONParser(jsonDecoder: JSONDecoder())
        let primary = MockCharacterServiceAPI()
        let fallback = CharacterServiceStorage(storage: CharactersCoreDataManager.shared)
        return primary.fallback(fallback)
    }
}
