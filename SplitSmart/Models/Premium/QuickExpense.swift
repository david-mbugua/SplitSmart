import Foundation
import SwiftData

@Model
final class QuickExpense {
    var id: UUID
    var amount: Decimal
    var title: String?
    var splitMembers: [String]
    var createdAt: Date
    var isProcessed: Bool
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        title: String? = nil,
        splitMembers: [String] = [],
        createdAt: Date = Date(),
        isProcessed: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.title = title
        self.splitMembers = splitMembers
        self.createdAt = createdAt
        self.isProcessed = isProcessed
    }
}