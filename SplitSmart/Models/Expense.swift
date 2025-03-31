import SwiftUI
import Foundation
import SwiftData

@Model
final class Expense: Identifiable {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var date: Date
    var title: String
    var category: ExpenseCategory
    var notes: String?
    var isRecurring: Bool
    var recurringInterval: RecurringInterval?
    var splitMembers: [String]?
    var receiptImageURL: URL?
    @Relationship(inverse: \Group.expenses) var group: Group?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        date: Date = Date(),
        title: String,
        category: ExpenseCategory = .other,
        notes: String? = nil,
        isRecurring: Bool = false,
        recurringInterval: RecurringInterval? = nil,
        splitMembers: [String]? = nil,
        receiptImageURL: URL? = nil,
        group: Group? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.title = title
        self.category = category
        self.notes = notes
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
        self.splitMembers = splitMembers
        self.receiptImageURL = receiptImageURL
        self.group = group
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
