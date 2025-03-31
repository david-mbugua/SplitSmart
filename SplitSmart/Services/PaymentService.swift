import Foundation

@Observable
class PaymentService {
    static let shared = PaymentService()
    
    var availablePaymentMethods: [PaymentMethod] = []
    var linkedAccounts: [PaymentAccount] = []
    
    private init() {
        loadPaymentMethods()
    }
    
    func linkAccount(method: PaymentMethod) async throws -> PaymentAccount {
        // TODO: Implement actual payment service integration
        // This would typically involve OAuth or similar authentication
        let account = PaymentAccount(
            id: UUID(),
            methodId: method.id,
            accountIdentifier: "test@example.com",
            isVerified: true
        )
        linkedAccounts.append(account)
        return account
    }
    
    func processPayment(amount: Decimal, from: String, to: String, method: PaymentMethod) async throws -> PaymentTransaction {
        // TODO: Implement actual payment processing
        // This would integrate with the actual payment service APIs
        let transaction = PaymentTransaction(
            id: UUID(),
            amount: amount,
            fromUser: from,
            toUser: to,
            methodId: method.id,
            status: .completed,
            timestamp: Date()
        )
        return transaction
    }
    
    private func loadPaymentMethods() {
        availablePaymentMethods = [
            PaymentMethod(
                id: "venmo",
                name: "Venmo",
                icon: "v.circle.fill",
                color: Color.Brand.sapphire,
                isAvailable: true
            ),
            PaymentMethod(
                id: "paypal",
                name: "PayPal",
                icon: "p.circle.fill",
                color: Color.Brand.amethyst,
                isAvailable: true
            ),
            PaymentMethod(
                id: "cashapp",
                name: "Cash App",
                icon: "dollarsign.circle.fill",
                color: Color.Status.success,
                isAvailable: true
            ),
            PaymentMethod(
                id: "zelle",
                name: "Zelle",
                icon: "z.circle.fill",
                color: Color.Brand.ruby,
                isAvailable: true
            )
        ]
    }
}

struct PaymentMethod: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let isAvailable: Bool
}

struct PaymentAccount: Identifiable {
    let id: UUID
    let methodId: String
    let accountIdentifier: String
    let isVerified: Bool
}

struct PaymentTransaction: Identifiable {
    let id: UUID
    let amount: Decimal
    let fromUser: String
    let toUser: String
    let methodId: String
    let status: TransactionStatus
    let timestamp: Date
    
    enum TransactionStatus: String {
        case pending
        case completed
        case failed
    }
}