import SwiftUI

struct ExpensesView: View {
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Monthly Overview Card
                    MonthlyOverviewCard(
                        spent: 850,
                        budget: 1500
                    )
                    
                    // Quick Add Button
                    Button {
                        showingAddExpense = true
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .primaryButton()
                    
                    // Recent Expenses
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Expenses")
                            .headingStyle()
                        
                        ForEach(ExpenseCategory.mockExpenses) { expense in
                            ExpenseRow(expense: expense)
                        }
                    }
                    .cardStyle()
                }
                .padding()
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Expenses")
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
            .environmentObject(ThemeManager())
    }
}