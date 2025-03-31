import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let expense: Expense
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(spacing: 12) {
                    Image(systemName: expense.category.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(expense.category.color)
                    
                    Text(expense.title)
                        .font(.title2.bold())
                    
                    Text(expense.amount, format: .currency(code: "USD"))
                        .font(.title.bold())
                        .foregroundStyle(expense.category.color)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    detailSection("Date", value: expense.date.formatted(date: .long, time: .omitted))
                    detailSection("Category", value: expense.category.rawValue)
                    
                    if expense.isRecurring {
                        detailSection("Recurring", value: expense.recurringInterval?.rawValue.capitalized ?? "Not specified")
                    }
                    
                    if let notes = expense.notes {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                            Text(notes)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color.Card.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    if let members = expense.splitMembers, !members.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Split with")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
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
                        .background(Color.Card.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    if let receiptURL = expense.receiptImageURL {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Receipt")
                                .font(.headline)
                            
                            AsyncImage(url: receiptURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .padding()
                        .background(Color.Card.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit", action: { showingEditSheet = true })
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddExpenseView(expense: expense)
        }
        .alert("Delete Expense", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) { deleteExpense() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this expense?")
        }
    }
    
    private func detailSection(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func deleteExpense() {
        modelContext.delete(expense)
        dismiss()
    }
}
