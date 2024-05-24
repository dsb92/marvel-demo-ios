// MARK: - StoryList
struct StoryList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummary]?
}
