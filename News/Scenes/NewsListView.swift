import Foundation
import SwiftUI

struct NewsListView: View {
    @State var viewModel: NewsViewModel
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
                                    .task(id: index) {
                                        if index >= viewModel.articles.count - preloadThreshold {
                                            await viewModel.fetchNextPageIfNeeded(currentIndex: index)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

                .navigationTitle("News")
            }
        }
        .task {
            await viewModel.initialLoad()
        }
        .refreshable {
            await viewModel.initialLoad()
        }
    }
}

#Preview {
    
    NewsListView(viewModel: NewsViewModel())

}
