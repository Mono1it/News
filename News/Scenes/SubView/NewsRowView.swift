import Foundation
import SwiftUI
import Kingfisher

struct NewsRowView: View {
    let article: Article

    var body: some View {
        VStack(spacing: 12) {

            RemoteImageView(url: article.urlToImage)

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(article.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)

                    Text(article.author ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Text(article.description ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
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
    
    NewsRowView(article: article)
}
