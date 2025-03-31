import SwiftUI

struct SettlementView: View {
    @Environment(\.dismiss) private var dismiss
    let settlements: [Settlement]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if settlements.isEmpty {
                        Text("No settlements needed!")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(settlements) { settlement in
                            SettlementRowView(settlement: settlement)
                        }
                    }
                } header: {
                    Text("Suggested Settlements")
                } footer: {
                    Text("These are the most efficient ways to settle the group's balances.")
                }
            }
            .navigationTitle("Settle Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct SettlementRowView: View {
    let settlement: Settlement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(settlement.from)
                    .font(.headline)
                Text("pays")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(settlement.to)
                    .font(.headline)
            }
            
            Spacer()
            
            Text(settlement.formattedAmount)
                .bold()
                .foregroundStyle(Color.Status.success)
        }
        .padding(.vertical, 4)
    }
}