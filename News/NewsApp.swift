import SwiftUI

@main
@MainActor
struct NewsApp: App {
    
    var body: some Scene {
        WindowGroup {
            NewsListView(viewModel: NewsViewModel())
        }
    }
}
