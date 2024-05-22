import XCTest

@testable import MarvelDemoApp

class MD5HasherTests: XCTestCase {
    func testMD5Hasher() {
        let privateKey = "abcd"
        let publicKey = "1234"
        let ts = "1"
        let string = "\(ts)\(privateKey)\(publicKey)"
        
        let md5Hasher = MD5Hasher()
        let result = md5Hasher.hash(string)
        let expected = "ffd275c5130566a2916217b101f26150"
        
        XCTAssertEqual(result, expected)
    }
}
