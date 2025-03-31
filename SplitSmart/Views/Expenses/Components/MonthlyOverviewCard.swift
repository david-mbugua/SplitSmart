import SwiftUI

struct MonthlyOverviewCard: View {
    let spent: Double
    let budget: Double
    
    private var progress: Double {
        spent / budget
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Monthly Overview")
                    .headingStyle()
                Spacer()
                Text(Date(), format: .dateTime.month(.wide))
                    .subheadingStyle()
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Spent")
                        .bodyStyle()
                    Spacer()
                    Text(spent, format: .currency(code: "USD"))
                        .bodyStyle()
                }
                
                HStack {
                    Text("Budget")
                        .bodyStyle()
                    Spacer()
                    Text(budget, format: .currency(code: "USD"))
                        .bodyStyle()
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.Background.secondary)
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(SplitSmartGradients.primaryGradient)
                            .frame(width: geometry.size.width * progress, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding()
        .cardStyle()
    }
}
