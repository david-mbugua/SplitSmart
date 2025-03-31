import SwiftUI

struct GroupBalanceView: View {
    let group: Group
    @State private var showingSettlements = false
    
    var balances: [Balance] {
        calculateBalances()
    }
    
    var settlements: [Settlement] {
        calculateSettlements()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Balances")
                    .font(.headline)
                Spacer()
                Button(action: { showingSettlements.toggle() }) {
                    Label("Settle Up", systemImage: "arrow.left.arrow.right")
                        .font(.subheadline)
                }
            }
            
            // Individual Balances
            ForEach(balances) { balance in
                HStack {
                    Text(balance.member)
                    Spacer()
                    Text(balance.formattedNetBalance)
                        .foregroundStyle(balance.isPositive ? Color.Status.success : Color.Status.error)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showingSettlements) {
            SettlementView(settlements: settlements)
        }
    }
    
    private func calculateBalances() -> [Balance] {
        var memberBalances: [String: Balance] = [:]
        
        // Initialize balances for all members
        for member in group.members {
            memberBalances[member] = Balance(member: member, paid: 0, owes: 0)
        }
        
        // Calculate paid amounts and owed amounts
        for expense in group.expenses {
            guard let payer = expense.splitMembers?.first else { continue }
            
            let amount = expense.amount
            let splitCount = max(1, expense.splitMembers?.count ?? 1)
            let splitAmount = amount / Decimal(splitCount)
            
            // Add to payer's paid amount
            if var payerBalance = memberBalances[payer] {
                payerBalance.paid += amount
                memberBalances[payer] = payerBalance
            }
            
            // Add to others' owed amounts
            for member in (expense.splitMembers ?? []) {
                if member != payer {
                    if var memberBalance = memberBalances[member] {
                        memberBalance.owes += splitAmount
                        memberBalances[member] = memberBalance
                    }
                }
            }
        }
        
        return Array(memberBalances.values)
    }
    
    private func calculateSettlements() -> [Settlement] {
        var settlements: [Settlement] = []
        var balances = calculateBalances()
        
        // Sort balances by net amount (descending)
        balances.sort { $0.netBalance > $1.netBalance }
        
        var i = 0
        var j = balances.count - 1
        
        while i < j {
            let creditor = balances[i]
            let debtor = balances[j]
            
            if creditor.netBalance <= 0 || debtor.netBalance >= 0 {
                break
            }
            
            let settlementAmount = min(abs(debtor.netBalance), creditor.netBalance)
            
            if settlementAmount > 0 {
                settlements.append(Settlement(
                    from: debtor.member,
                    to: creditor.member,
                    amount: settlementAmount
                ))
            }
            
            if abs(debtor.netBalance) == creditor.netBalance {
                i += 1
                j -= 1
            } else if abs(debtor.netBalance) < creditor.netBalance {
                j -= 1
            } else {
                i += 1
            }
        }
        
        return settlements
    }
}