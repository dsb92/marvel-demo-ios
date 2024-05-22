import Foundation
import CryptoKit

protocol HasherSchema {
    func hash(_ string: String) -> String
}

struct MD5Hasher: HasherSchema {
    func hash(_ string: String) -> String {
        let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
