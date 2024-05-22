import Foundation

struct MockURLRequestBuilder: URLRequestBuilderSchema {
    var error: Error?
    
    func buildURLRequest(from request: Request) throws -> URLRequest {
        if let error {
            throw error
        }
        guard let url = URL(string: request.url) else {
            throw URLError(.badURL)
        }
        return URLRequest(url: url)
    }
}
