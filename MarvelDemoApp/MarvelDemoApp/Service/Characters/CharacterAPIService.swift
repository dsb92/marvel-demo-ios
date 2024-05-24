import Foundation

struct CharacterAPIService: CharacterServiceSchema {
    let apiClient: APIClientSchema
    let parser: JSONParserSchema
    
    func getCharacters(
        parameters: CharacterGetParameters
    ) async throws -> CharacterDataWrapper? {
        let request = APIRequest(
            path: "/v1/public/characters",
            parameters: parameters.toDictionary(),
            method: "GET",
            headers: nil,
            body: nil
        )
        let response = try await apiClient.performRequest(request)
        return try parser.parse(CharacterDataWrapper.self, from: response.data)
    }
}
