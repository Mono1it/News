import SwiftUI

@main
struct NewsApp: App {
    @StateObject var viewModel = NewsViewModel()
    var body: some Scene {
        WindowGroup {
            NewsListView()
                .environmentObject(viewModel)
        }
    }
}
