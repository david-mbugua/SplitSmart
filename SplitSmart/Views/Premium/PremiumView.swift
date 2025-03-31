import SwiftUI

struct PremiumView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Card Example
                VStack(alignment: .leading, spacing: 12) {
                    Text("Premium Features")
                        .font(.title)
                        .bold()
                    
                    Text("Unlock advanced features with our premium subscription")
                        .font(.title3)
                    
                    Text("Starting at $4.99/month")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                
                // Buttons Example
                VStack(spacing: 16) {
                    Button("Upgrade Now") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Learn More") {
                        // Action
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                // Status Colors Example
                HStack(spacing: 20) {
                    StatusIndicator(color: .green, text: "Paid")
                    StatusIndicator(color: .orange, text: "Pending")
                    StatusIndicator(color: .red, text: "Failed")
                }
            }
            .padding()
        }
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PremiumView()
        }
    }
}