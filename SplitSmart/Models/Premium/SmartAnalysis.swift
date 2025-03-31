import Foundation

struct SpendingInsight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: InsightType
    let relevanceScore: Double // 0-1, how important/relevant this insight is
    
    enum InsightType {
        case alert // Unusual spending
        case trend // Spending pattern
        case suggestion // Money-saving tip
        case achievement // Positive milestone
    }
}

struct SpendingPattern {
    let category: ExpenseCategory
    let frequency: Double // Average occurrences per month
    let averageAmount: Decimal
    let timeOfDay: TimeOfDay // When expenses usually occur
    let dayOfWeek: DayOfWeek // Which days expenses usually occur
    
    enum TimeOfDay: String {
        case morning = "Morning (6AM-12PM)"
        case afternoon = "Afternoon (12PM-5PM)"
        case evening = "Evening (5PM-10PM)"
        case night = "Night (10PM-6AM)"
    }
    
    enum DayOfWeek: String, CaseIterable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }
}