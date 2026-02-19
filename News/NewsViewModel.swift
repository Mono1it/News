import Foundation

@MainActor
@Observable
final class NewsViewModel {
    var articles: [Article] = []
    var isLoading = false
    var error: Error?
    var selectedCategory: NewsCategory = .business
    
    private var pageNumber: Int = 1
    private let pageSize: Int = 20
    
    let provider: NewsProvider
    
    init(provider: NewsProvider = NewsProvider()) {
        self.provider = provider
    }
    
//    func setCategory(category: NewsCategory) {
//        if category == selectedCategory || isLoading {
//            return
//        }
//        selectedCategory = category
//        initialLoad()
//    }
    
    func initialLoad() async {
        isLoading = true
        error = nil
        pageNumber = 1
        
        do {
            let articles = try await provider.fetchNews(
                pageNumber: pageNumber,
                pageSize: pageSize,
                category: selectedCategory)
            
            self.pageNumber += 1
            self.articles = articles
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func fetchNextPage() async {
        if isLoading {
            return
        }
        
        isLoading = true
        
        do {
            let articles = try await provider.fetchNews(
                pageNumber: pageNumber,
                pageSize: pageSize,
                category: selectedCategory)
            
            self.pageNumber += 1
            self.articles.append(contentsOf: articles)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func fetchNextPageIfNeeded(currentIndex: Int) async {
        guard currentIndex >= articles.count - 2 else { return }
        await fetchNextPage()
    }
    
    func loadMockData() async {
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
