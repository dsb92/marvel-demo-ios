// MARK: - ComicSummary
struct ComicSummary: Codable {
    let resourceURI: String?
    let name: String?
}

extension ComicSummary: Hashable {}
