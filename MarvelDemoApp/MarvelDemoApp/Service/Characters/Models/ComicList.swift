// MARK: - ComicList
struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}
