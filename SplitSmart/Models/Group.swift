import Foundation
import SwiftData

@Model
final class Group {
    var id: UUID
    var name: String
    var members: [String]
    var color: String
    @Relationship(deleteRule: .nullify) var expenses: [Expense]
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        members: [String] = [],
        color: String = "sapphire",
        expenses: [Expense] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.members = members
        self.color = color
        self.expenses = expenses
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}