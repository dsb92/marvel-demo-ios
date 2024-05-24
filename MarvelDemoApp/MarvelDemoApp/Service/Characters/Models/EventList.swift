// MARK: - EventList
struct EventList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [EventSummary]?
}
