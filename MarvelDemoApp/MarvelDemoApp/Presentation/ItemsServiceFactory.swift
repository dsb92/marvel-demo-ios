protocol ItemsServiceFactorySchema {
    func createItemsService() -> ItemsService
}

struct ItemsServiceFactory: ItemsServiceFactorySchema {
    func createItemsService() -> ItemsService {
        CharacterItemsServiceAdapter(service: CharacterServiceFactory().createCharacterService())
    }
}
