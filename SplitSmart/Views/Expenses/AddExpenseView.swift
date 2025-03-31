import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var amount = 0.0
    @State private var category = ExpenseCategory.food
    @State private var note = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    
                    HStack {
                        Text("$")
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: "")
                                .foregroundColor(category.color)
                        }
                    }
                }
                
                Section {
                    TextField("Note (Optional)", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        // TODO: Add expense
                        dismiss()
                    }
                }
            }
        }
    }
}