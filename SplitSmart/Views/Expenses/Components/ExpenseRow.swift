import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(expense.category.color)
                .frame(width: 40, height: 40)
                .overlay(expense.category.icon.foregroundColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                Text(expense.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(Color.Text.secondary)
            }
            
            Spacer()
            
            Text(expense.amount, format: .currency(code: "USD"))
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}