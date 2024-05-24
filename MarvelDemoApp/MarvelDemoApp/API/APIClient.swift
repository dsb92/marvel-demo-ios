import Foundation

protocol APIClientSchema {
    func getHostURL() -> String
    func performRequest(_ request: APIRequest) async throws -> Response
}

struct APIRequest {
    let path: String
    let parameters: [String: Any]
    let method: String
    let headers: [String: String]?
    let body: Data?
}

struct APIClient: APIClientSchema {
    let networkClient: NetworkClientSchema
    let environmentReader: EnvironmentReaderSchema
    let hasher: HasherSchema
    
    func performRequest(_ request: APIRequest) async throws -> Response {
        let authParameters = [
            "apiKey": getAPIKey(),
            "hash": getHash(),
            "ts": getTS()
        ]
        let url = getHostURL() + request.path + request.parameters.merge(with: authParameters).toQueryString()
        return try await networkClient.performRequest(Request(url: url, method: request.method, headers: request.headers, body: request.body))
    }

    func getHostURL() -> String {
        "http://gateway.marvel.com"
    }
    
    private func getAPIKey() -> String {
        environmentReader.value(for: "API_PUBLIC_KEY") ?? ""
    }
    
    private func getPrivateKey() -> String {
        environmentReader.value(for: "API_PRIVATE_KEY") ?? ""
    }
    
    private func getHash() -> String {
        hasher.hash(getTS() + getPrivateKey() + getAPIKey())
    }
    
    private func getTS() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date.now)
    }
}
