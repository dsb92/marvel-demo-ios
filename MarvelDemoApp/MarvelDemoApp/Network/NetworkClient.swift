protocol NetworkClientSchema {
    func performRequest(_ request: Request) async throws -> Response
}
