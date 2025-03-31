import SwiftUI
import SwiftData
import Charts

@Observable
class ReportsViewModel {
    var expenses: [Expense]
    
    init(expenses: [Expense]) {
        self.expenses = expenses
    }
    
    // Update value types to be consistent
    var totalSpending: Decimal {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var averageExpenseAmount: Decimal {
        guard !expenses.isEmpty else { return 0 }
        return totalSpending / Decimal(expenses.count)
    }
    
    var mostExpensiveCategory: (ExpenseCategory, Decimal)? {
        Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { expenses in
                expenses.reduce(0) { $0 + $1.amount }
            }
            .max(by: { $0.value < $1.value })
    }
    
    struct CategorySpending: Identifiable {
        let category: ExpenseCategory
        let amount: Decimal
        let percentage: Double
        
        var id: ExpenseCategory { category }
    }
    
    var categorySpending: [CategorySpending] {
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.category })
        let total = totalSpending
        
        return groupedExpenses.map { category, expenses in
            let amount = expenses.reduce(0) { $0 + $1.amount }
            let percentage = total > 0 ? NSDecimalNumber(decimal: amount / total).doubleValue : 0
            return CategorySpending(category: category, amount: amount, percentage: percentage)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    struct MonthlySpending: Identifiable {
        let month: Date
        let amount: Decimal
        let count: Int
        
        var id: Date { month }
    }
    
    var monthlySpending: [MonthlySpending] {
        let calendar = Calendar.current
        let groupedExpenses = Dictionary(grouping: expenses) { expense in
            calendar.startOfMonth(for: expense.date)
        }
        
        return groupedExpenses.map { month, expenses in
            MonthlySpending(
                month: month,
                amount: expenses.reduce(0) { $0 + $1.amount },
                count: expenses.count
            )
        }
        .sorted { $0.month < $1.month }
    }
    
    // MARK: - Trends
    
    var spendingTrend: Double {
        guard monthlySpending.count >= 2 else { return 0 }
        let lastMonth = monthlySpending.last!.amount
        let previousMonth = monthlySpending[monthlySpending.count - 2].amount
        
        guard previousMonth != 0 else { return 1 }
        return NSDecimalNumber(decimal: (lastMonth - previousMonth) / previousMonth).doubleValue
    }
}

// MARK: - Calendar Extension
private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
