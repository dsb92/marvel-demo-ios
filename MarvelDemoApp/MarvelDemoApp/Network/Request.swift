import Foundation

struct Request {
    let url: String
    let method: String
    let headers: [String: String]?
    let body: Data?
}
