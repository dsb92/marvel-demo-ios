protocol ItemsServiceFactorySchema {
    func createItemsService() -> ItemsServiceSchema
}

struct ItemsServiceFactory: ItemsServiceFactorySchema {
    func createItemsService() -> ItemsServiceSchema {
        CharacterItemsServiceAdapter(service: CharacterServiceFactory().createCharacterService())
    }
}
