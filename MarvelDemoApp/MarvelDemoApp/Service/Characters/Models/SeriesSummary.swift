// MARK: - SeriesSummary
struct SeriesSummary: Codable {
    let resourceURI: String?
    let name: String?
}

extension SeriesSummary: Hashable {}
extension SeriesSummary: Nameable {}
