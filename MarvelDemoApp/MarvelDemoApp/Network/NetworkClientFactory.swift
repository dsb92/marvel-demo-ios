import Foundation

protocol NetworkClientFactorySchema {
    func createNetworkClient() -> NetworkClientSchema
}

struct NetworkClientFactory: NetworkClientFactorySchema {
    func createNetworkClient() -> NetworkClientSchema {
        let urlRequestBuilder = URLRequestBuilder()
        let urlSession = URLSession.shared
        return URLRequestNetworkClient(urlRequestBuilder: urlRequestBuilder, urlSession: urlSession)
    }
}
