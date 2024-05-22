import Foundation

struct Response {
    let data: Data
    let statusCode: Int
    let headers: [String: String]
}
