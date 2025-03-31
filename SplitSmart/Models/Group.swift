import Foundation
import SwiftUI
import SwiftData

@Model
final class Group: Identifiable {
    var id: UUID
    var name: String
    var members: [String]
    var color: String
    @Relationship(deleteRule: .cascade) var expenses: [Expense]
    var createdAt: Date
    var updatedAt: Date
    
    var totalExpenses: Decimal {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var averageExpenseAmount: Decimal {
        guard !expenses.isEmpty else { return 0 }
        return totalExpenses / Decimal(expenses.count)
    }
    
    enum GroupColor: String, CaseIterable {
        case sapphire
        case emerald
        case amethyst
        case ruby
        
        var uiColor: Color {
            switch self {
            case .sapphire: return .Brand.sapphire
            case .emerald: return .Brand.emerald
            case .amethyst: return .Brand.amethyst
            case .ruby: return .Brand.ruby
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        members: [String] = [],
        color: String = GroupColor.sapphire.rawValue,
        expenses: [Expense] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.members = members.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        self.color = color
        self.expenses = expenses
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func addMember(_ member: String) {
        let trimmedMember = member.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMember.isEmpty,
              !members.contains(trimmedMember) else { return }
        members.append(trimmedMember)
        updatedAt = Date()
    }
    
    func removeMember(_ member: String) {
        members.removeAll { $0 == member }
        updatedAt = Date()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        updatedAt = Date()
    }
    
    func removeExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        updatedAt = Date()
    }
    
    func updateColor(_ newColor: GroupColor) {
        color = newColor.rawValue
        updatedAt = Date()
    }
    
    func rename(_ newName: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        name = trimmedName
        updatedAt = Date()
    }
}

// MARK: - Convenience Extensions
extension Group {
    var displayColor: Color {
        if let groupColor = GroupColor(rawValue: color) {
            return groupColor.uiColor
        }
        return .Brand.sapphire
    }
    
    var sortedExpenses: [Expense] {
        expenses.sorted { $0.date > $1.date }
    }
    
    var recentExpenses: [Expense] {
        Array(sortedExpenses.prefix(5))
    }
    
    func memberBalance(for member: String) -> Decimal {
        var balance: Decimal = 0
        
        for expense in expenses {
            if expense.splitMembers?.first == member {
                // Member paid for the expense
                balance += expense.amount
            }
            
            if let splitMembers = expense.splitMembers,
               splitMembers.contains(member) {
                // Member's share of the expense
                balance -= expense.amount / Decimal(splitMembers.count)
            }
        }
        
        return balance
    }
}
