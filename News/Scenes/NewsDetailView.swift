import Foundation
import SwiftUI
import Kingfisher

struct NewsDetailView:View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack {
                RemoteImageView(url: article.urlToImage)
                    .padding()
                
                Text(DateFormatter.newsDate.string(from: article.publishedAt))
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                
                Text(article.title)
                    .font(.title)
                    .bold()
                    .padding()
                
                Text(article.content ?? "")
                    .font(.caption)
                    .padding(.horizontal)
                
                NavigationLink {
                    ArticleWebView(url: article.url)
                } label: {
                    Text("Read full article")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 12)
                }
            }
        }
        .navigationTitle(article.author ?? "")
    }
}

#Preview {
    let article: Article = Article(
        source: Source(
            id: nil,
            name: "Mattrichman.net"
        ),
        author: "John Gruber",
        title: "SwiftUI упрощает разработку интерфейсов",
        description: "Краткое описание новости для списка.",
        url: URL(string: "https://example.com/article-1")!,
        urlToImage: URL(string: "https://picsum.photos/600/400"),
        publishedAt: Date(),
        content: """
        SwiftUI — это декларативный фреймворк для построения пользовательских интерфейсов.

        Он позволяет описывать UI как функцию от состояния, упрощая поддержку и развитие приложений.
        """
    )
    
    NewsDetailView(article: article)
}

extension DateFormatter {
    static let newsDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
