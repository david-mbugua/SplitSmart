import Foundation
import SwiftUI

class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremium: Bool = false
    @Published var features: [PremiumFeature] = PremiumFeature.allFeatures
    
    private init() {}
    
    func purchasePremium() async throws {
        // TODO: Implement StoreKit purchase
        isPremium = true
    }
    
    func restorePurchases() async throws {
        // TODO: Implement StoreKit restore
    }
}

struct PremiumFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    
    static let allFeatures: [PremiumFeature] = [
        PremiumFeature(
            title: "Challenge Mode",
            description: "Compete with friends in savings challenges",
            icon: "trophy.fill"
        ),
        PremiumFeature(
            title: "Smart Analysis",
            description: "AI-powered spending insights",
            icon: "brain.head.profile"
        ),
        PremiumFeature(
            title: "Currency Conversion",
            description: "Real-time international rates",
            icon: "dollarsign.arrow.circlepath"
        ),
        PremiumFeature(
            title: "Split Now, Log Later",
            description: "Quick-action expense splitting",
            icon: "clock.arrow.circlepath"
        ),
        PremiumFeature(
            title: "Scan & Split",
            description: "Receipt scanning with item attribution",
            icon: "doc.text.viewfinder"
        ),
        PremiumFeature(
            title: "Payment Integration",
            description: "Direct settlement through popular services",
            icon: "creditcard.fill"
        )
    ]
}
