import XCTest

@testable import MarvelDemoApp

class CharacterServiceTests: XCTestCase {
    func testGetCharactersWithMockService() async throws {
        let mockService = MockCharacterService()
        
        let parameters = CharacterGetParameters()
        
        let result = try await mockService.getCharacters(parameters: parameters)
        
        XCTAssertNotNil(result)
    }
}
