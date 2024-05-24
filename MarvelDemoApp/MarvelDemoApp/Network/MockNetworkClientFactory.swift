import Foundation

struct MockNetworkClientFactory: NetworkClientFactorySchema {
    func createNetworkClient() -> NetworkClientSchema {
        let mockURLRequestBuilder = MockURLRequestBuilder()
        let mockURLSession = MockURLSession()
        return URLRequestNetworkClient(urlRequestBuilder: mockURLRequestBuilder, urlSession: mockURLSession)
    }
}
