// MARK: - EventSummary
struct EventSummary: Codable {
    let resourceURI: String?
    let name: String?
}

extension EventSummary: Nameable {}
