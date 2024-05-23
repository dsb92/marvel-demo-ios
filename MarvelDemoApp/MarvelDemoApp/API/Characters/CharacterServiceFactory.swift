import Foundation

protocol CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema
}

struct CharacterServiceFactory: CharacterServiceFactorySchema {
    func createCharacterService() -> CharacterServiceSchema {
        let apiClient = APIClientFactory().createAPIClient()
        let apiParser = SimpleJSONParser(jsonDecoder: JSONDecoder())
        let primary = CharacterAPIService(apiClient: apiClient, parser: apiParser)
        let fallback = CharacterStorageService(storage: CharactersCoreDataManager.shared)
        return primary.fallback(fallback)
    }
}
