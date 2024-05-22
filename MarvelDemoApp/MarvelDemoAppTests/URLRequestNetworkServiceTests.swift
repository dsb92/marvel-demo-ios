import XCTest

@testable import MarvelDemoApp

class URLRequestNetworkServiceTests: XCTestCase {
    func testPerformRequestSuccess() async throws {
        let mockData = "{\"key\":\"value\"}".data(using: .utf8)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com/data")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        
        var mockSession = MockURLSession()
        mockSession.data = mockData
        mockSession.response = mockResponse
        
        let urlRequestBuilder = MockURLRequestBuilder()
        
        let networkService = URLRequestNetworkService(urlRequestBuilder: urlRequestBuilder, urlSession: mockSession)
        
        let request = Request(url: "https://api.example.com/data", method: "GET", headers: nil, body: nil)
        
        let response = try await networkService.performRequest(request)
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.data, mockData)
    }
    
    func testPerformRequestFailure() async throws {
        let mockError = URLError(.notConnectedToInternet)
        
        var mockSession = MockURLSession()
        mockSession.error = mockError
        
        let mockUrlRequestBuilder = MockURLRequestBuilder()
        
        let networkService = URLRequestNetworkService(urlRequestBuilder: mockUrlRequestBuilder, urlSession: mockSession)
        
        let request = Request(url: "https://api.example.com/data", method: "GET", headers: nil, body: nil)
        
        do {
            _ = try await networkService.performRequest(request)
            XCTFail("Expected to throw error, but it succeeded")
        } catch {
            XCTAssertEqual(error as? URLError, mockError)
        }
    }
}
