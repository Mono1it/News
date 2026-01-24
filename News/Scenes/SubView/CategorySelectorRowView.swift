import SwiftUI

struct CategorySelectorRowView: View {
    let category: String
    let isSelected: Bool
    
    var body: some View {
            Text(category)
                .font(.callout)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .foregroundColor(isSelected ? .primary : .secondary)
                .bold(isSelected)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(isSelected ? 0.6 : 0.2))
                )
    }
}

#Preview {
    CategorySelectorRowView(category: "Sport", isSelected: true)
}
