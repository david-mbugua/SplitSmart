import SwiftUI
import SwiftData

struct QuickSplitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount = 0.0
    @State private var title = ""
    @State private var selectedMembers: [String] = []
    @State private var showingMemberPicker = false
    
    let group: Group?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Amount Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.headline)
                    
                    HStack {
                        Text("$")
                            .font(.title)
                        
                        TextField("0.00", value: $amount, format: .currency(code: "USD"))
                            .font(.system(size: 48, weight: .bold))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Title
                TextField("Quick note (optional)", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                // Members
                Button(action: { showingMemberPicker = true }) {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Split with \(selectedMembers.isEmpty ? "..." : "\(selectedMembers.count) people")")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.Card.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                if !selectedMembers.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedMembers, id: \.self) { member in
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
                
                Spacer()
                
                // Save Button
                Button(action: saveQuickExpense) {
                    Text("Split Now, Add Details Later")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.Brand.sapphire)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(amount == 0 || selectedMembers.isEmpty)
            }
            .padding()
            .navigationTitle("Quick Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showingMemberPicker) {
                SplitMembersView(splitMembers: $selectedMembers)
            }
        }
    }
    
    private func saveQuickExpense() {
        let quickExpense = QuickExpense(
            amount: Decimal(amount),
            title: title.isEmpty ? nil : title,
            splitMembers: selectedMembers
        )
        
        modelContext.insert(quickExpense)
        dismiss()
    }
}