import Foundation

// CHANGE: Add CaseIterable protocol
enum RecurringInterval: String, CaseIterable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}