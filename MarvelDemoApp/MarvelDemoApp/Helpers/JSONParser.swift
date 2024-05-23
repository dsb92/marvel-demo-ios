import Foundation

protocol JSONParserSchema {
    func parse<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

struct SimpleJSONParser: JSONParserSchema {
    let jsonDecoder: JSONDecoder
    
    func parse<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(type, from: data)
    }
}
