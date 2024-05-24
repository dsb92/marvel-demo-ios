struct MockItemsServiceFactory: ItemsServiceFactorySchema {
    func createItemsService() -> ItemsServiceSchema {
        MockCharacterItemsServiceAdapter(service: MockCharacterServiceFactory().createCharacterService())
    }
}
