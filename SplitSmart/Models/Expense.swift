import SwiftUI

struct Expense: Identifiable {
    let id = UUID()
    let category: ExpenseCategory
    let amount: Double
    let title: String
    let date: Date
    var note: String?
}

enum ExpenseCategory: String, CaseIterable {
    case food = "Food & Drinks"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case other = "Other"
    
    var icon: Image {
        Image(systemName: iconName)
    }
    
    private var iconName: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .entertainment: return "film.fill"
        case .utilities: return "bolt.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .emerald
        case .transport: return .sapphire
        case .shopping: return .amethyst
        case .entertainment: return .ruby
        case .utilities: return .warning
        case .other: return .textSecondary
        }
    }
    
    // Mock data for previews
    static var mockExpenses: [Expense] {
        [
            Expense(category: .food, amount: 25.50, title: "Lunch", date: .now),
            Expense(category: .transport, amount: 35.00, title: "Uber", date: .now),
            Expense(category: .entertainment, amount: 50.00, title: "Movie Night", date: .now),
            Expense(category: .shopping, amount: 120.00, title: "Groceries", date: .now)
        ]
    }
}