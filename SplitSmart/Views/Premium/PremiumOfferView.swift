import SwiftUI

struct PremiumOfferView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var isProcessing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.Brand.sapphire)
                        
                        Text("Unlock Premium Features")
                            .font(.title.bold())
                        
                        Text("Take your expense splitting to the next level")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    // Feature List
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(PremiumFeature.allFeatures) { feature in
                            HStack(spacing: 16) {
                                Image(systemName: feature.icon)
                                    .font(.title2)
                                    .foregroundStyle(Color.Brand.sapphire)
                                    .frame(width: 32)
                                
                                VStack(alignment: .leading) {
                                    Text(feature.title)
                                        .font(.headline)
                                    Text(feature.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.Card.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Purchase Button
                    Button(action: purchasePremium) {
                        if isProcessing {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Upgrade Now")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.Brand.sapphire)
                    .disabled(isProcessing)
                    
                    // Restore Purchases
                    Button("Restore Purchases", action: restorePurchases)
                        .disabled(isProcessing)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func purchasePremium() {
        isProcessing = true
        
        Task {
            do {
                try await premiumManager.purchasePremium()
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
            
            await MainActor.run {
                isProcessing = false
            }
        }
    }
    
    private func restorePurchases() {
        isProcessing = true
        
        Task {
            do {
                try await premiumManager.restorePurchases()
                if premiumManager.isPremium {
                    await MainActor.run {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
            
            await MainActor.run {
                isProcessing = false
            }
        }
    }
}