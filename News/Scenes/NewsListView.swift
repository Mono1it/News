import Foundation
import SwiftUI

struct NewsListView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    private let preloadThreshold = 2
    @State var isCategoryBarVisible = true
    
    var body: some View {
        NavigationStack {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        
                        Color.clear
                            .frame(height: 1)
                            .id("top")
                        
                        ForEach(
                            Array(viewModel.articles.enumerated()),
                            id: \.element.id
                        ) { index, article in
                            
                            NavigationLink {
                                NewsDetailView(article: article)
                            } label: {
                                NewsRowView(article: article)
                                    .onAppear {
                                        if index >= viewModel.articles.count - preloadThreshold {
                                            viewModel.fetchNextPageIfNeeded(currentIndex: index)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: viewModel.selectedCategory) {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
                
                .navigationTitle("News")
                .safeAreaInset(edge: .top, spacing: 8) {
                    if isCategoryBarVisible {
                        CategoryScrollView()
                            .padding(8)
                            .background {
                                Capsule()
                                    .fill(.thinMaterial)
                                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentOffset.y
                }
                action: { oldValue, newValue in
                    let delta = newValue - oldValue
                    
                    if delta > 16 {
                        withAnimation(.easeInOut) {
                            isCategoryBarVisible = false
                        }
                    }
                    
                    if delta < -16 {
                        withAnimation(.easeInOut) {
                            isCategoryBarVisible = true
                        }
                    }
                }
            }
        }
        .task {
            viewModel.initialLoad()
        }
        .refreshable {
            viewModel.initialLoad()
        }
    }
}

#Preview {
    let viewModel = NewsViewModel()
    viewModel.articles = [
        Article(
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
        ),
        Article(
            source: Source(
                id: nil,
                name: "Github.com"
            ),
            author: nil,
            title: "Handy — open source speech-to-text",
            description: "Бесплатное офлайн приложение для распознавания речи.",
            url: URL(string: "https://example.com/article-2")!,
            urlToImage: URL(string: "https://picsum.photos/600/401"),
            publishedAt: Date(),
            content: """
                Handy — это кроссплатформенное приложение для распознавания речи,
                работающее полностью офлайн.
                
                Проект построен с использованием Rust и Tauri.
                """
        )
    ]
    
    
    return NewsListView()
        .environmentObject(viewModel)
}
