import Foundation

protocol URLRequestBuilderSchema {
    func buildURLRequest(from request: Request) throws -> URLRequest
}

struct URLRequestBuilder: URLRequestBuilderSchema {
    func buildURLRequest(from request: Request) throws -> URLRequest {
        guard let url = URL(string: request.url) else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        return urlRequest
    }
}

protocol URLSessionSchema {
    func makeRequest(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionSchema {
    func makeRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}

struct URLRequestNetworkService: NetworkServiceSchema {
    let urlRequestBuilder: URLRequestBuilderSchema
    let urlSession: URLSessionSchema
    
    func performRequest(_ request: Request) async throws -> Response {
        let urlRequest = try urlRequestBuilder.buildURLRequest(from: request)
        
        let (data, urlResponse) = try await urlSession.makeRequest(for: urlRequest)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let responseHeaders = httpResponse.allHeaderFields as? [String: String] ?? [:]
        let response = Response(data: data, statusCode: httpResponse.statusCode, headers: responseHeaders)
        
        return response
    }
}

