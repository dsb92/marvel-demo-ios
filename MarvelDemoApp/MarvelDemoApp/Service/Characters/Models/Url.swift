// MARK: - Url
struct Url: Codable {
    let type: String?
    let url: String?
}

extension Url: Hashable {}
