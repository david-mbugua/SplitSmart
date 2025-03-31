import Foundation

@Observable
class CurrencyService {
    static let shared = CurrencyService()
    
    var availableCurrencies: [Currency] = []
    var exchangeRates: [String: Decimal] = [:]
    private var lastFetchedDate: Date?
    
    private init() {
        loadCurrencies()
    }
    
    func convert(_ amount: Decimal, from sourceCurrency: String, to targetCurrency: String) -> Decimal {
        guard let sourceRate = exchangeRates[sourceCurrency],
              let targetRate = exchangeRates[targetCurrency],
              sourceRate > 0 else {
            return amount
        }
        return (amount / sourceRate) * targetRate
    }
    
    @MainActor
    func fetchLatestRates() async throws {
        // TODO: Implement actual API call
        // For now, using mock data
        exchangeRates = [
            "USD": 1.0,
            "EUR": 0.92,
            "GBP": 0.79,
            "JPY": 148.45,
            "CAD": 1.35
        ]
        lastFetchedDate = Date()
    }
    
    private func loadCurrencies() {
        availableCurrencies = [
            Currency(code: "USD", name: "US Dollar", symbol: "$"),
            Currency(code: "EUR", name: "Euro", symbol: "€"),
            Currency(code: "GBP", name: "British Pound", symbol: "£"),
            Currency(code: "JPY", name: "Japanese Yen", symbol: "¥"),
            Currency(code: "CAD", name: "Canadian Dollar", symbol: "C$")
        ]
    }
}

struct Currency: Identifiable {
    let code: String
    let name: String
    let symbol: String
    
    var id: String { code }
}