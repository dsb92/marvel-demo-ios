extension Dictionary {
    func merge(with other: Dictionary) -> Dictionary {
        var result = self
        for (key, value) in other {
            result[key] = value
        }
        return result
    }
}
