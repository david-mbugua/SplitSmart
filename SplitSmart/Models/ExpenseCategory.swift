import SwiftUI

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case utilities = "Utilities"
    case health = "Health"
    case housing = "Housing"
    case travel = "Travel"
    case education = "Education"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transportation:
            return "car.fill"
        case .entertainment:
            return "theatermasks.fill"
        case .shopping:
            return "cart.fill"
        case .utilities:
            return "bolt.fill"
        case .health:
            return "heart.fill"
        case .housing:
            return "house.fill"
        case .travel:
            return "airplane"
        case .education:
            return "book.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food:
            return .orange
        case .transportation:
            return .blue
        case .entertainment:
            return .purple
        case .shopping:
            return .green
        case .utilities:
            return .yellow
        case .health:
            return .red
        case .housing:
            return .brown
        case .travel:
            return .cyan
        case .education:
            return .indigo
        case .other:
            return .gray
        }
    }
}
