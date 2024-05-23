extension Dictionary where Key == String, Value == Any {
    func toQueryString() -> String {
        var result = ""
        for (key, value) in self {
            if !result.isEmpty {
                result += "&"
            }
            result += "\(key)=\(value)"
        }
        return result
    }
}
