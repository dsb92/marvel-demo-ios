// MARK: - SeriesList
struct SeriesList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummary]?
}
