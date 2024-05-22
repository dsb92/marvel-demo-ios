// MARK: - Character
struct ´Character´: Codable {
    let id: Int?
    let name: String?
    let description: String
    let modified: String?
    let resourceURI: String?
    let urls: [Url]?
    let thumbnail: ´Image´?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?
}
