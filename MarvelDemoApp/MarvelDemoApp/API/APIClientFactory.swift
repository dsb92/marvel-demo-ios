import Foundation

protocol APIClientFactorySchema {
    func createAPIClient() -> APIClientSchema
}

struct APIClientFactory: APIClientFactorySchema {
    func createAPIClient() -> APIClientSchema {
        let networkClient = NetworkServiceFactory().createNetworkService()
        let environmentReader = EnvironmentReader()
        let hasher = MD5Hasher()
        return APIClient(networkClient: networkClient, environmentReader: environmentReader, hasher: hasher)
    }
}

struct MockAPIClientFactory: APIClientFactorySchema {
    func createAPIClient() -> APIClientSchema {
        let networkClient = MockNetworkServiceFactory().createNetworkService()
        let environmentReader = MockEnvironmentReader(environment: ["API_PUBLIC_KEY": "test", "API_PRIVATE_KEY": "test", "ts": "1"])
        let hasher = MD5Hasher()
        return APIClient(networkClient: networkClient, environmentReader: environmentReader, hasher: hasher)
    }
}
