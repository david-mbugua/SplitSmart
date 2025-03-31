import SwiftUI
import SwiftData

struct GroupBalanceView: View {
    let group: Group
    @StateObject private var premiumManager = PremiumManager.shared
    
    @State private var showingSettlements = false
    @State private var selectedSettlement: Settlement?
    @State private var animateBalances = false
    
    private var balances: [Balance] {
        calculateBalances()
            .sorted { abs($0.netBalance) > abs($1.netBalance) }
    }
    
    private var settlements: [Settlement] {
        calculateSettlements()
    }
    
    private var hasBalances: Bool {
        balances.contains { $0.netBalance != 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Balances")
                    .font(.headline)
                Spacer()
                if hasBalances {
                    Button(action: { showingSettlements.toggle() }) {
                        Label("Settle Up", systemImage: "arrow.left.arrow.right")
                            .font(.subheadline)
                    }
                    .disabled(!premiumManager.isPremium)
                }
            }
            
            // Individual Balances
            if balances.isEmpty {
                Text("No balances to show")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(balances) { balance in
                    BalanceRowView(balance: balance)
                        .opacity(animateBalances ? 1 : 0)
                        .offset(x: animateBalances ? 0 : -20)
                        .animation(.easeOut(duration: 0.3).delay(Double(balances.firstIndex(where: { $0.id == balance.id }) ?? 0) * 0.1),
                                 value: animateBalances)
                }
            }
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showingSettlements) {
            SettlementView(settlements: settlements)
        }
        .sheet(item: $selectedSettlement) { settlement in
            SettlePaymentView(settlement: settlement)
        }
        .onAppear {
            animateBalances = true
        }
    }
    
    private func calculateBalances() -> [Balance] {
        var memberBalances: [String: Balance] = [:]
        
        // Initialize balances for all members
        for member in group.members {
            memberBalances[member] = Balance(
                member: member,
                paid: 0,
                owes: 0
            )
        }
        
        // Calculate paid amounts and owed amounts
        for expense in group.expenses {
            guard let payer = expense.splitMembers?.first else { continue }
            
            let amount = expense.amount
            let splitCount = max(1, expense.splitMembers?.count ?? 1)
            let splitAmount = amount / Decimal(splitCount)
            
            // Add to payer's paid amount
            memberBalances[payer]?.paid += amount
            
            // Add to others' owed amounts
            for member in (expense.splitMembers ?? []) where member != payer {
                memberBalances[member]?.owes += splitAmount
            }
        }
        
        return Array(memberBalances.values)
    }
    
    private func calculateSettlements() -> [Settlement] {
        var settlements: [Settlement] = []
        var balances = calculateBalances()
        
        // Sort balances by net amount (descending)
        balances.sort { $0.netBalance > $1.netBalance }
        
        var creditors = balances.filter { $0.netBalance > 0 }
        var debtors = balances.filter { $0.netBalance < 0 }
        
        while !creditors.isEmpty && !debtors.isEmpty {
            let creditor = creditors[0]
            let debtor = debtors[0]
            
            let settlementAmount = min(creditor.netBalance, abs(debtor.netBalance))
            
            if settlementAmount > 0 {
                settlements.append(Settlement(
                    from: debtor.member,
                    to: creditor.member,
                    amount: settlementAmount
                ))
            }
            
            if creditor.netBalance == settlementAmount {
                creditors.removeFirst()
            } else {
                var updatedCreditor = creditor
                updatedCreditor.paid -= settlementAmount
                creditors[0] = updatedCreditor
            }
            
            if abs(debtor.netBalance) == settlementAmount {
                debtors.removeFirst()
            } else {
                var updatedDebtor = debtor
                updatedDebtor.owes -= settlementAmount
                debtors[0] = updatedDebtor
            }
        }
        
        return settlements
    }
}

struct BalanceRowView: View {
    let balance: Balance
    
    var body: some View {
        HStack {
            Text(balance.member)
            Spacer()
            Text(balance.formattedNetBalance)
                .foregroundStyle(balance.isPositive ? Color.Status.success : Color.Status.error)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}
