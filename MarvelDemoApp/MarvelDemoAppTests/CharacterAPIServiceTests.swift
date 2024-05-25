import XCTest

@testable import MarvelDemoApp

class CharacterAPIServiceTests: XCTestCase {
    func testGetCharactersWithMockService() async throws {
        let mockService = MockCharacterServiceAPI()
        
        let parameters = CharacterGetParameters()
        
        let result = try await mockService.getCharacters(parameters: parameters)
        
        XCTAssertNotNil(result)
    }
}
