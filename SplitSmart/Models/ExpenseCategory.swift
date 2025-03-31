import Foundation

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case rent = "Rent"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .entertainment: return "film.fill"
        case .utilities: return "bolt.fill"
        case .rent: return "house.fill"
        case .other: return "circle.fill"
        }
    }
}