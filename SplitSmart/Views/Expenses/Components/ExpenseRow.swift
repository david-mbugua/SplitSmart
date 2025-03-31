import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Image(systemName: expense.category.icon)
                .foregroundStyle(expense.category.color)
            
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                Text(expense.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(expense.amount, format: .currency(code: "USD"))
                .bold()
        }
        .padding(.vertical, 8)
    }
}
