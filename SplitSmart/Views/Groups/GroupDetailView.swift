import SwiftUI
import SwiftData

struct GroupDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let group: Group
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingAddExpense = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.Brand.sapphire)
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "person.3.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    
                    Text(group.name)
                        .font(.title2.bold())
                    
                    Text("\(group.members.count) members")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Members
                GroupMembersView(members: group.members)
                
                // Expenses
                GroupExpensesView(
                    expenses: group.expenses,
                    onAddExpense: { showingAddExpense.toggle() }
                )
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit Group", action: { showingEditSheet = true })
                    Button("Delete Group", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditGroupView(group: group)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(group: group)
        }
        .alert("Delete Group", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) { deleteGroup() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this group? This action cannot be undone.")
        }
    }
    
    private func deleteGroup() {
        modelContext.delete(group)
        dismiss()
    }
}

struct GroupMembersView: View {
    let members: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Members")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(members, id: \.self) { member in
                        Text(member)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.Brand.sapphire.opacity(0.2))
                            .foregroundStyle(Color.Brand.sapphire)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct GroupExpensesView: View {
    let expenses: [Expense]
    let onAddExpense: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Expenses")
                    .font(.headline)
                Spacer()
                Button(action: onAddExpense) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            
            if expenses.isEmpty {
                Text("No expenses yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(expenses) { expense in
                    ExpenseRowView(expense: expense)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}