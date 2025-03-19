struct PixabayResponse: Codable {

    let total: Int
    let totalHits: Int
    let hits: [PixabayImage]
}

// MARK: - Image

struct PixabayImage: Codable {

    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let webformatURL: String
    let largeImageURL: String
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user: String
}
