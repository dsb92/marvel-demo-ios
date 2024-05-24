import XCTest

@testable import MarvelDemoApp

class CharacterServiceWithFallbackTests: XCTestCase {
    func testPrimaryServiceSucceeds() async {
        let primaryService = MockCharacterAPIService()
        let fallbackService = MockFallbackCharacterService()
        let serviceWithFallback = primaryService.fallback(fallbackService)
        let parameters = CharacterGetParameters()

        do {
            let result = try await serviceWithFallback.getCharacters(parameters: parameters)

            XCTAssertNotNil(result, "Expected primary service to succeed and return result (no fallback needed)")
        } catch {
            XCTFail("Expected primary service to succeed, but it failed with error: \(error)")
        }
    }
    
    func testFallbackServiceSucceeds() async {
        let primaryService = MockThrowErrorCharacterAPIService()
        let fallbackService = MockFallbackCharacterService()
        let serviceWithFallback = primaryService.fallback(fallbackService)
        let parameters = CharacterGetParameters()

        do {
            let result = try await serviceWithFallback.getCharacters(parameters: parameters)

            XCTAssertNotNil(result, "Expected fallback service to succeed and return result (no primary needed)")
        } catch {
            XCTFail("Expected fallback service to succeed, but it failed with error: \(error)")
        }
    }
}
