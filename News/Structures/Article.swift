import Foundation

struct NewsRequest: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: Date
    let content: String?
    
    var id: URL {url}
}

struct Source: Decodable, Identifiable {
    let id: String?
    let name: String
}
