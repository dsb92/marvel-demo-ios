import Foundation

protocol EnvironmentReaderSchema {
    func value(for key: String) -> String?
}

struct EnvironmentReader: EnvironmentReaderSchema {
    func value(for key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}

struct MockEnvironmentReader: EnvironmentReaderSchema {
    let environment: [String: String]
    
    func value(for key: String) -> String? {
        return environment[key]
    }
}
