import CoreData
import Foundation
import OSLog

protocol CharactersStorageSchema {
    func save(characters: [´Character´]) async throws
    func fetchAll() async throws -> [´Character´]
}

class CharactersCoreDataManager: CharactersStorageSchema {
    static let shared = CharactersCoreDataManager()
    
    private init() {}
    
    private let logger = Logger(subsystem: "CoreData", category: "Characters")
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CharactersDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                self.logger.error("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext(context: NSManagedObjectContext) {
         if context.hasChanges {
             do {
                 try context.save()
                 logger.debug("Core data saved")
             } catch {
                 let nserror = error as NSError
                 logger.error("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         } else {
             logger.debug("Unchanged dore data")
         }
     }
    
    func save(characters: [´Character´]) async throws {
        logger.debug("Saving \(characters.count) characters from core-data...")

        let context = backgroundContext
        await context.perform {
            for character in characters {
                let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", character.id ?? 0)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    let entity: CharacterEntity
                    if let existingEntity = results.first {
                        // Update existing entity
                        entity = existingEntity
                    } else {
                        // Create new entity
                        entity = CharacterEntity(context: context)
                    }
                    
                    entity.id = Int64(character.id ?? 0)
                    entity.name = character.name
                    entity.desc = character.description
                    entity.modified = character.modified
                    entity.resourceURI = character.resourceURI
                    if let urls = character.urls {
                        for url in urls {
                            let urlEntity = UrlEntity(context: context)
                            urlEntity.type = url.type
                            urlEntity.url = url.url

                            entity.addToUrls(urlEntity)
                        }
                    }
                    if let thumbnail = character.thumbnail {
                        let imageEntity = ImageEntity(context: context)
                        imageEntity.path = thumbnail.path
                        imageEntity.thumbnailExtension = thumbnail.thumbnailExtension

                        entity.thumbnail = imageEntity
                    }
                    if let comics = character.comics {
                        let comicsEntity = ComicListEntity(context: context)
                        comicsEntity.available = Int64(comics.available ?? 0)
                        comicsEntity.returned = Int64(comics.returned ?? 0)
                        comicsEntity.collectionURI = comics.collectionURI
                        if let items = comics.items {
                            for item in items {
                                let comicSummaryEntity = ComicSummaryEntity(context: context)
                                comicSummaryEntity.resourceURI = item.resourceURI
                                comicSummaryEntity.name = item.name

                                comicsEntity.addToItems(comicSummaryEntity)
                            }
                        }
                        entity.comics = comicsEntity
                    }
                    if let stories = character.stories {
                        let storiesEntity = StoryListEntity(context: context)
                        storiesEntity.available = Int64(stories.available ?? 0)
                        storiesEntity.returned = Int64(stories.returned ?? 0)
                        storiesEntity.collectionURI = stories.collectionURI
                        if let items = stories.items {
                            for item in items {
                                let storySummaryEntity = StorySummaryEntity(context: context)
                                storySummaryEntity.resourceURI = item.resourceURI
                                storySummaryEntity.name = item.name
                                storySummaryEntity.type = item.type

                                storiesEntity.addToItems(storySummaryEntity)
                            }
                        }
                        entity.stories = storiesEntity
                    }
                    if let events = character.events {
                        let eventsEntity = EventListEntity(context: context)
                        eventsEntity.available = Int64(events.available ?? 0)
                        eventsEntity.returned = Int64(events.returned ?? 0)
                        eventsEntity.collectionURI = events.collectionURI
                        if let items = events.items {
                            for item in items {
                                let eventSummaryEntity = EventSummaryEntity(context: context)
                                eventSummaryEntity.resourceURI = item.resourceURI
                                eventSummaryEntity.name = item.name

                                eventsEntity.addToItems(eventSummaryEntity)
                            }
                        }
                        entity.events = eventsEntity
                    }
                    if let series = character.series {
                        let seriesEntity = SeriesListEntity(context: context)
                        seriesEntity.available = Int64(series.available ?? 0)
                        seriesEntity.returned = Int64(series.returned ?? 0)
                        seriesEntity.collectionURI = seriesEntity.collectionURI
                        if let items = series.items {
                            for item in items {
                                let seriesSummaryEntity = SeriesSummaryEntity(context: context)
                                seriesSummaryEntity.resourceURI = item.resourceURI
                                seriesSummaryEntity.name = item.name

                                seriesEntity.addToItems(seriesSummaryEntity)
                            }
                        }
                        entity.series = seriesEntity
                    }
                } catch {
                    self.logger.error("Failed to fetch or save character: \(error)")
                }
            }
        }
        
        saveContext(context: context)
    }
    
    func fetchAll() async throws -> [´Character´] {
        logger.debug("Fetching characters from coredata...")

        return try await withCheckedThrowingContinuation { continuation in
            let context = viewContext
            context.perform {
                let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                fetchRequest.relationshipKeyPathsForPrefetching = [
                    "thumbnail",
                    "urls",
                    "comics",
                    "comics.items",
                    "stories", 
                    "stories.items",
                    "series",
                    "series.items",
                    "events",
                    "events.items"
                ]
                do {
                    let characterEntities = try context.fetch(fetchRequest)
                    let characters = characterEntities.compactMap { entity in
                        ´Character´(
                            id: Int(entity.id),
                            name: entity.name,
                            description: entity.desc,
                            modified: entity.modified,
                            resourceURI: entity.resourceURI,
                            urls: entity.urls.array(of: Url.self),
                            thumbnail: ´Image´(path: entity.thumbnail?.path, thumbnailExtension: entity.thumbnail?.thumbnailExtension),
                            comics: ComicList(available: Int(entity.comics?.available ?? 0), returned: Int(entity.comics?.returned ?? 0), collectionURI: entity.comics?.collectionURI, items: entity.comics?.items.array(of: ComicSummaryEntity.self).compactMap { ComicSummary(resourceURI: $0.resourceURI, name: $0.name) }),
                            stories: StoryList(available: Int(entity.stories?.available ?? 0), returned: Int(entity.stories?.returned ?? 0), collectionURI: entity.stories?.collectionURI, items: entity.stories?.items.array(of: StorySummaryEntity.self).compactMap { StorySummary(resourceURI: $0.resourceURI, name: $0.name, type: $0.type) }),
                            events: EventList(available: Int(entity.events?.available ?? 0), returned: Int(entity.events?.returned ?? 0), collectionURI: entity.events?.collectionURI, items: entity.events?.items.array(of: EventSummaryEntity.self).compactMap { EventSummary(resourceURI: $0.resourceURI, name: $0.name) }),
                            series: SeriesList(available: Int(entity.series?.available ?? 0), returned: Int(entity.series?.returned ?? 0), collectionURI: entity.series?.collectionURI, items: entity.series?.items.array(of: SeriesSummaryEntity.self).compactMap { SeriesSummary(resourceURI: $0.resourceURI, name: $0.name) })
                        )
                    }
                    self.logger.debug("Loaded \(characterEntities.count) from coredata")
                    continuation.resume(returning: characters)
                } catch {
                    self.logger.error("Failed to fetchAll characters: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
