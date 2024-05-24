// MARK: - StorySummary
struct StorySummary: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

extension StorySummary: Hashable {}
extension StorySummary: Nameable {}
