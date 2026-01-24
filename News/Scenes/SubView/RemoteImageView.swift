import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let url: URL?

    var body: some View {
        KFImage(url)
            .placeholder {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                    ProgressView()
                }
            }
            .resizable()
            .scaledToFit()
            .clipped()
            .cornerRadius(16)
    }
}

#Preview {
    RemoteImageView(url: URL(string: "https://picsum.photos/600/400"))
}
