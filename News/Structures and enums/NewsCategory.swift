import Foundation

enum NewsCategory: CaseIterable, Identifiable {
    var id: NewsCategory { self }
    
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    
    var apiValue: String {
        switch self {
        case .business: "business"
        case .entertainment: "entertainment"
        case .general: "general"
        case .health: "health"
        case .science: "science"
        case .sports: "sports"
        case .technology: "technology"
        }
    }
    
    var title: String {
        switch self {
        case .business: "Business"
        case .entertainment: "Entertainment"
        case .general: "General"
        case .health: "Health"
        case .science: "Science"
        case .sports: "Sports"
        case .technology: "Technology"
        }
    }
}
