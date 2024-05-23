import Foundation

protocol NetworkServiceFactorySchema {
    func createNetworkService() -> NetworkServiceSchema
}

struct NetworkServiceFactory: NetworkServiceFactorySchema {
    func createNetworkService() -> NetworkServiceSchema {
        let urlRequestBuilder = URLRequestBuilder()
        let urlSession = URLSession.shared
        return URLRequestNetworkService(urlRequestBuilder: urlRequestBuilder, urlSession: urlSession)
    }
}
