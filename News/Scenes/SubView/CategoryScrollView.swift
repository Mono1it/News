import SwiftUI

//struct CategoryScrollView: View {
//    
//    @EnvironmentObject var viewModel: NewsViewModel
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack {
//                ForEach(NewsCategory.allCases) { category in
//                    Button {
//                        viewModel.setCategory(category: category)
//                    } label: {
//                        CategorySelectorRowView(category: category.title, isSelected: viewModel.selectedCategory == category)
//                    }
//                }
//                .buttonStyle(.plain)
//                .animation(.default, value: viewModel.selectedCategory)
//            }
//        }
//        .frame(height: 44)
//        .scrollIndicators(.hidden)
//        .scrollBounceBehavior(.basedOnSize)
//        .scrollTargetBehavior(.viewAligned)
//        
//    }
//}
