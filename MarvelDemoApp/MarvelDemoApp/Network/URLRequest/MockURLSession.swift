import Foundation

struct MockURLSession: URLSessionSchema {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func makeRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
