import XCTest
import CoreData

@testable import MarvelDemoApp

class CharactersCoreDataManagerTests: XCTestCase {
    var charactersCoreDataManager: CharactersCoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()

        mockPersistentContainer = {
            let container = NSPersistentContainer(name: "CharactersDataModel")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        
        charactersCoreDataManager = CharactersCoreDataManager.shared
        charactersCoreDataManager.persistentContainer = mockPersistentContainer
    }
    
    override func tearDown() {
        charactersCoreDataManager = nil
        mockPersistentContainer = nil
        super.tearDown()
    }
    
    func testSaveCharacters() {
        let characters = [´Character´(id: 1, name: "Spider-Man", description: "A superhero", modified: nil, resourceURI: nil, urls: [Url(type: nil, url: "http://example.com")], thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)]
        
        charactersCoreDataManager.save(characters: characters)
        
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.relationshipKeyPathsForPrefetching = ["urls"]

        do {
            let results = try mockPersistentContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            let characterEntity = results.first
            XCTAssertEqual(characterEntity?.name, "Spider-Man")
            XCTAssertEqual(characterEntity?.desc, "A superhero")
            XCTAssertEqual((characterEntity?.urls?.allObjects as? [UrlEntity])?.first?.url, "http://example.com")
        } catch {
            XCTFail("Fetch request failed with error: \(error)")
        }
    }
    
    func testFetchUrlsRelationship() {
        let character = ´Character´(id: 1, name: "Spider-Man", description: "A superhero", modified: nil, resourceURI: nil, urls: [Url(type: nil, url: "http://example.com")], thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
        
        let characterEntity = CharacterEntity(context: mockPersistentContainer.viewContext)
        characterEntity.id = Int64(character.id ?? 0)
        characterEntity.name = character.name
        characterEntity.desc = character.description
        
        if let urls = character.urls {
            for url in urls {
                let urlEntity = UrlEntity(context: mockPersistentContainer.viewContext)
                urlEntity.url = url.url

                characterEntity.addToUrls(urlEntity)
            }
        }

        do {
            try mockPersistentContainer.viewContext.save()
        } catch {
            XCTFail("Failed to save CharacterEntity with URLs: \(error)")
        }
        

        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", Int32(character.id ?? 0))
        fetchRequest.relationshipKeyPathsForPrefetching = ["urls"]
        
        do {
            let fetchedCharacters = try mockPersistentContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(fetchedCharacters.count, 1, "Expected to fetch 1 CharacterEntity")
            let fetchedCharacter = fetchedCharacters.first
            XCTAssertNotNil(fetchedCharacter, "Fetched CharacterEntity should not be nil")
            
            // Then
            let fetchedUrls = fetchedCharacter?.urls?.allObjects as? [UrlEntity]
            XCTAssertEqual(fetchedUrls?.count, 1, "Expected to fetch 1 UrlEntity")
            let fetchedUrl = fetchedUrls?.first
            XCTAssertNotNil(fetchedUrl, "Fetched UrlEntity should not be nil")
            XCTAssertEqual(fetchedUrl?.url, "http://example.com", "Expected URL should match")
        } catch {
            XCTFail("Failed to fetch CharacterEntity with URLs: \(error)")
        }
    }
}
