import Foundation



final class NewsProvider {
    private let apiKey: String = Constants.apiKey
    private var task: URLSessionTask?
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func makeNewsRequest(pageNumber: Int, pageSize: Int, category: NewsCategory) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: "\(category.apiValue)"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        guard let url = components.url else {
            preconditionFailure("Невозможно создать URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
    
    func fetchNews(pageNumber: Int, pageSize: Int, category: NewsCategory) async throws -> [Article] {
        
        let request = makeNewsRequest(
            pageNumber: pageNumber,
            pageSize: pageSize,
            category: category
        )
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatusCode(httpResponse.statusCode)
        }
        
        decoder.dateDecodingStrategy = .iso8601
        
        let decoded = try decoder.decode(NewsRequest.self, from: data)
        
        return decoded.articles
    }
    
}
