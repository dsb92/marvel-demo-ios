import XCTest

@testable import MarvelDemoApp

class EnvironmentReaderTests: XCTestCase {
    func testValueForExistingKey() {
        let key = "TEST_KEY"
        let value = "TEST_VALUE"
        let mockEnvironmentReader = MockEnvironmentReader(environment: [key: value])
        
        let result = mockEnvironmentReader.value(for: key)
        
        XCTAssertEqual(result, value)
    }
    
    func testValueForNonExistingKey() {
         let key = "NON_EXISTING_KEY"
         let mockEnvironmentReader = MockEnvironmentReader(environment: [:])
         
         let result = mockEnvironmentReader.value(for: key)
         
         XCTAssertNil(result)
     }
}
