import SwiftUI

struct PremiumOverlayView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumOffer = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.Brand.sapphire)
                
                Text("Premium Feature")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Text("Upgrade to SplitSmart Premium to access this feature and more!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.8))
                
                Button(action: { showingPremiumOffer = true }) {
                    Text("Upgrade Now")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Brand.sapphire)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .sheet(isPresented: $showingPremiumOffer) {
            PremiumOfferView()
        }
    }
}