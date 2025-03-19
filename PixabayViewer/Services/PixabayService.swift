import Foundation

final class PixabayService {

    // MARK: - Private Properties

    private let apiKey: String

    private let baseURL = "https://pixabay.com/api/"

    // MARK: - Init

    init(apiKey: String = "38738026-cb365c92113f40af7a864c24a") {
        self.apiKey = apiKey
    }
}

// MARK: - PixabayServiceProtocol

extension PixabayService: PixabayServiceProtocol {

    func getImages(query: String, page: Int) async throws -> PixabayResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "per_page", value: String(10)),
            URLQueryItem(name: "page", value: String(page)),
        ]

        guard let url = components?.url else { throw PixabayError.default }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        let response = try decoder.decode(PixabayResponse.self, from: data)

        return response
    }
}
