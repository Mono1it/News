import Foundation



final class NewsProvider {
    private let apiKey: String = Constants.apiKey
    private var task: URLSessionTask?
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func makeNewsRequest(pageNumber: Int, pageSize: Int, category: NewsCategory) -> URLRequest? {
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
    
    func fetchNews(pageNumber: Int, pageSize: Int, category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard
            let request = makeNewsRequest(pageNumber: pageNumber, pageSize: pageSize, category: category)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        self.task = urlSession.objectTask(for: request) { (result: Result<NewsRequest, Error>) in
            switch result {
            case .success(let response):
                let articles = response.articles
                completion(.success(articles))
            case .failure(let error):
                if case let NetworkError.httpStatusCode(code) = error {
                    print("NewsApi вернул ошибку. Код: \(code)")
                } else {
                    print("Ошибка: \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
}
