protocol PixabayServiceProtocol {

    func getImages(query: String, page: Int) async throws -> PixabayResponse
}
