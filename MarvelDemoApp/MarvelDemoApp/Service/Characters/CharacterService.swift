protocol CharacterServiceSchema {
    func getCharacters(
        parameters: CharacterGetParameters
    ) async throws -> CharacterDataWrapper?
    
    func saveCharacters(_ characters: CharacterDataWrapper?)
}


struct CharacterGetParameters {
    var name: String? = nil
    var nameStartsWith: String? = nil
    var modifiedSince: String? = nil
    var comics: Int? = nil
    var series: Int? = nil
    var events: Int? = nil
    var stories: Int? = nil
    var orderBy: String? = nil
    var limit: Int? = nil
    var offset: Int? = nil
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if let name { dict["name"] = name }
        if let nameStartsWith { dict["nameStartsWith"] = nameStartsWith }
        if let modifiedSince { dict["modifiedSince"] = modifiedSince }
        if let comics { dict["comics"] = comics }
        if let series { dict["series"] = series }
        if let events { dict["events"] = events }
        if let stories { dict["stories"] = stories }
        if let orderBy { dict["orderBy"] = orderBy }
        if let limit { dict["limit"] = limit }
        if let offset { dict["offset"] = offset }
        return dict
    }
}
