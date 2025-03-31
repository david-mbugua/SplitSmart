import Foundation

struct Balance: Identifiable {
    let id = UUID()
    let member: String
    var paid: Decimal
    var owes: Decimal
    
    var netBalance: Decimal {
        paid - owes
    }
    
    var formattedNetBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: netBalance as NSDecimalNumber) ?? "$0.00"
    }
    
    var isPositive: Bool {
        netBalance > 0
    }
}

struct Settlement: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let amount: Decimal
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
}