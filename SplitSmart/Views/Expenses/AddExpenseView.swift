import SwiftUI
import PhotosUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var amount: Double = 0.0
    @State private var date = Date()
    @State private var category: ExpenseCategory = .other
    @State private var notes = ""
    @State private var isRecurring = false
    @State private var recurringInterval: RecurringInterval?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var receiptImage: Image?
    @State private var showingSplitOptions = false
    @State private var splitMembers: [String] = []
    @State private var selectedCurrency = "USD"
    @StateObject private var currencyService = CurrencyService.shared
    @StateObject private var premiumManager = PremiumManager.shared
    let expense: Expense?
    let group: Group?
    
    init(expense: Expense? = nil, group: Group? = nil) {
        self.expense = expense
        self.group = group
        
        if let expense = expense {
            _title = State(initialValue: expense.title)
            _amount = State(initialValue: (expense.amount as NSDecimalNumber).doubleValue)
            _date = State(initialValue: expense.date)
            _category = State(initialValue: expense.category)
            _notes = State(initialValue: expense.notes ?? "")
            _isRecurring = State(initialValue: expense.isRecurring)
            _recurringInterval = State(initialValue: expense.recurringInterval)
            _splitMembers = State(initialValue: expense.splitMembers ?? [])
        }
        
        if let group = group {
            _splitMembers = State(initialValue: group.members)
        }
    }
    
    var body: some View {
        NavigationStack {
            ExpenseFormContent(
                title: $title,
                amount: $amount,
                date: $date,
                category: $category,
                notes: $notes,
                isRecurring: $isRecurring,
                recurringInterval: $recurringInterval,
                selectedPhoto: $selectedPhoto,
                receiptImage: $receiptImage,
                showingSplitOptions: $showingSplitOptions,
                splitMembers: $splitMembers,
                selectedCurrency: $selectedCurrency,
                premiumManager: premiumManager,
                currencyService: currencyService
            )
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("DEBUG: Save button tapped")
                        print("DEBUG: Title: \(title)")
                        print("DEBUG: Amount: \(amount)")
                        saveExpense()
                    }
                    .disabled(title.isEmpty || amount <= 0)
                }
            }
            .sheet(isPresented: $showingSplitOptions) {
                SplitMembersView(splitMembers: $splitMembers)
            }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            loadTransferable(from: newValue)
        }
    }
    
    private func loadTransferable(from photoItem: PhotosPickerItem?) {
        Task {
            if let data = try? await photoItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                receiptImage = Image(uiImage: uiImage)
            }
        }
    }
    
    private func saveExpense() {
        var finalAmount = Decimal(amount)
        if selectedCurrency != "USD" {
            finalAmount = currencyService.convert(finalAmount, from: selectedCurrency, to: "USD")
        }
        
        let newExpense = Expense(
            amount: finalAmount,
            date: date,
            title: title,
            category: category,
            notes: notes.isEmpty ? nil : notes,
            isRecurring: isRecurring,
            recurringInterval: recurringInterval,
            splitMembers: splitMembers.isEmpty ? nil : splitMembers,
            group: group
        )
        
        modelContext.insert(newExpense)
        
        if let group = group {
            group.addExpense(newExpense)
        }
        
        dismiss()
    }
}

private struct ExpenseFormContent: View {
    @Binding var title: String
    @Binding var amount: Double
    @Binding var date: Date
    @Binding var category: ExpenseCategory
    @Binding var notes: String
    @Binding var isRecurring: Bool
    @Binding var recurringInterval: RecurringInterval?
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var receiptImage: Image?
    @Binding var showingSplitOptions: Bool
    @Binding var splitMembers: [String]
    @Binding var selectedCurrency: String
    let premiumManager: PremiumManager
    let currencyService: CurrencyService
    
    var body: some View {
        Form {
            basicInfoSection
            recurringSection
            splitOptionsSection
            notesSection
            receiptSection
        }
    }
    
    private var basicInfoSection: some View {
        Section {
            TextField("Title", text: $title)
            
            HStack {
                Text(selectedCurrency == "USD" ? "$" : selectedCurrency)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                    .onChange(of: amount) { _, newValue in
                        print("DEBUG: Amount changed to: \(newValue)")
                    }
            }
            
            if premiumManager.isPremium {
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(currencyService.availableCurrencies) { currency in
                        Text("\(currency.code) (\(currency.symbol))")
                            .tag(currency.code)
                    }
                }
            }
            
            DatePicker("Date", selection: $date, displayedComponents: [.date])
            
            Picker("Category", selection: $category) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        } header: {
            Text("Basic Information")
        }
    }
    
    private var recurringSection: some View {
        Section {
            Toggle("Recurring Expense", isOn: $isRecurring)
            
            if isRecurring {
                Picker("Interval", selection: $recurringInterval) {
                    Text("Select").tag(nil as RecurringInterval?)
                    ForEach(RecurringInterval.allCases, id: \.self) { interval in
                        Text(interval.rawValue.capitalized).tag(interval as RecurringInterval?)
                    }
                }
            }
        } header: {
            Text("Recurring Options")
        }
    }
    
    private var splitOptionsSection: some View {
        Section {
            Button(action: { showingSplitOptions.toggle() }) {
                HStack {
                    Text("Split with Others")
                    Spacer()
                    Text("\(splitMembers.count) people")
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("Split Options")
        }
    }
    
    private var notesSection: some View {
        Section {
            TextEditor(text: $notes)
                .frame(height: 100)
        } header: {
            Text("Notes")
        }
    }
    
    private var receiptSection: some View {
        Section {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                if let receiptImage {
                    receiptImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                } else {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                        Text("Add Receipt")
                    }
                }
            }
        } header: {
            Text("Receipt")
        }
    }
}
