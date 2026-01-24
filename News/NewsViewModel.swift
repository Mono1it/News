import Foundation
import Combine

enum NewsCategory: CaseIterable, Identifiable {
    var id: NewsCategory { self }
    
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    
    var apiValue: String {
        switch self {
        case .business: "business"
        case .entertainment: "entertainment"
        case .general: "general"
        case .health: "health"
        case .science: "science"
        case .sports: "sports"
        case .technology: "technology"
        }
    }
    
    var title: String {
        switch self {
        case .business: "Business"
        case .entertainment: "Entertainment"
        case .general: "General"
        case .health: "Health"
        case .science: "Science"
        case .sports: "Sports"
        case .technology: "Technology"
        }
    }
}

final class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedCategory: NewsCategory = .business
    
    private var pageNumber: Int = 1
    private let pageSize: Int = 20
    
    let provider: NewsProvider
    
    init(provider: NewsProvider = NewsProvider()) {
        self.provider = provider
    }
    
    func setCategory(category: NewsCategory) {
        if category == selectedCategory || isLoading {
            return
        }
        selectedCategory = category
        initialLoad()
    }
    
    func initialLoad() {
        isLoading = true
        error = nil
        pageNumber = 1
        
        provider.fetchNews(pageNumber: pageNumber, pageSize: pageSize, category: selectedCategory) { [weak self] result in
            guard let self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let articles):
                self.pageNumber += 1
                self.articles = articles
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchNextPage() {
        if isLoading {
            return
        }
        
        isLoading = true
        provider.fetchNews(pageNumber: pageNumber, pageSize: pageSize, category: selectedCategory) { [weak self] result in
            guard let self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let articles):
                self.pageNumber += 1
                self.articles.append(contentsOf: articles)
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= articles.count - 2 else { return }
        fetchNextPage()
    }
    
    func loadMockData() {
        guard let url = Bundle.main.url(forResource: "NewsMock", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decoded = try decoder.decode(NewsRequest.self, from: data)
            articles = decoded.articles
        } catch {
            print("Ошибка декодирования", error)
        }
    }
}
