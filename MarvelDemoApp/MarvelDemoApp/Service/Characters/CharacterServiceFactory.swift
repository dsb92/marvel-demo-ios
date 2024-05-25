import Foundation

protocol CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema
}

struct CharacterServiceFactory: CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema {
        let apiClient = APIClientFactory().createAPIClient()
        let apiParser = SimpleJSONParser(jsonDecoder: JSONDecoder())
        let primary = CharacterServiceAPI(apiClient: apiClient, parser: apiParser)
        let fallback = CharacterServiceStorage(storage: CharactersCoreDataManager.shared)
        return primary.fallback(fallback)
    }
}
