protocol NetworkServiceSchema {
    func performRequest(_ request: Request) async throws -> Response
}
