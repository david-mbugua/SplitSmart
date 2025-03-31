import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)]) private var expenses: [Expense]
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "dollarsign.circle",
                        description: Text("Tap the + button to add your first expense")
                    )
                } else {
                    List {
                        ForEach(expenses) { expense in
                            ExpenseRowView(expense: expense)
                        }
                        .onDelete(perform: deleteExpenses)
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddExpense.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
                    .onDisappear {
                        print("DEBUG: AddExpenseView disappeared")
                        // Try to manually fetch expenses
                        do {
                            let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                            let fetchedExpenses = try modelContext.fetch(descriptor)
                            print("DEBUG: Manually fetched \(fetchedExpenses.count) expenses after adding:")
                            fetchedExpenses.forEach { expense in
                                print("DEBUG: - \(expense.title): $\(expense.amount)")
                            }
                        } catch {
                            print("DEBUG: Error fetching expenses: \(error)")
                        }
                    }
            }
            .onAppear {
                print("DEBUG: ExpensesView appeared")
                print("DEBUG: Current expenses count: \(expenses.count)")
            }
        }
    }
    
    private func deleteExpenses(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(modelContext.delete)
        }
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        NavigationLink(destination: ExpenseDetailView(expense: expense)) {
            HStack {
                Image(systemName: expense.category.icon)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading) {
                    Text(expense.title)
                        .font(.headline)
                    Text(expense.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(expense.amount, format: .currency(code: "USD"))
                    .bold()
            }
            .padding(.vertical, 8)
        }
    }
}
