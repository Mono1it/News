import SwiftUI

struct ArticleWebView: View {
    let url: URL
    @State private var progress: Double = 0

    var body: some View {
        VStack(spacing: 0) {

            if progress < 1 {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .tint(.blue)
                    .frame(height: 2)
            }

            WebView(url: url, progress: $progress)
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
    }
}

