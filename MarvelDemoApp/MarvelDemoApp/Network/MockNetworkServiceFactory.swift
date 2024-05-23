import Foundation

struct MockNetworkServiceFactory: NetworkServiceFactorySchema {
    func createNetworkService() -> NetworkServiceSchema {
        let mockURLRequestBuilder = MockURLRequestBuilder()
        let mockURLSession = MockURLSession()
        return URLRequestNetworkService(urlRequestBuilder: mockURLRequestBuilder, urlSession: mockURLSession)
    }
}
