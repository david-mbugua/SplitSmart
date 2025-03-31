import SwiftUI
import SwiftData
import Charts

struct SmartAnalysisView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [Expense]
    
    var insights: [SpendingInsight] {
        generateInsights()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Insights Section
                ForEach(insights) { insight in
                    InsightCardView(insight: insight)
                }
                
                // Patterns Section
                if let patterns = analyzePatterns() {
                    PatternsSectionView(patterns: patterns)
                }
                
                // Predictions Section
                PredictionsSectionView(expenses: expenses)
            }
            .padding()
        }
        .navigationTitle("Smart Analysis")
    }
    
    private func generateInsights() -> [SpendingInsight] {
        // TODO: Implement actual AI analysis
        // For now, return mock insights
        [
            SpendingInsight(
                title: "Unusual Spending",
                description: "Your entertainment spending is 45% higher than usual this month",
                type: .alert,
                relevanceScore: 0.9
            ),
            SpendingInsight(
                title: "Saving Opportunity",
                description: "Switching your subscriptions to annual plans could save you $84/year",
                type: .suggestion,
                relevanceScore: 0.8
            ),
            SpendingInsight(
                title: "Great Progress!",
                description: "You've reduced your food delivery expenses by 30% this month",
                type: .achievement,
                relevanceScore: 0.7
            )
        ]
    }
    
    private func analyzePatterns() -> [SpendingPattern]? {
        // TODO: Implement actual pattern analysis
        // For now, return mock patterns
        [
            SpendingPattern(
                category: .food,
                frequency: 15.0,
                averageAmount: 25.0,
                timeOfDay: .evening,
                dayOfWeek: .friday
            ),
            SpendingPattern(
                category: .transportation,
                frequency: 20.0,
                averageAmount: 15.0,
                timeOfDay: .morning,
                dayOfWeek: .monday
            )
        ]
    }
}

struct InsightCardView: View {
    let insight: SpendingInsight
    
    var insightColor: Color {
        switch insight.type {
        case .alert: return Color.Status.error
        case .trend: return Color.Brand.sapphire
        case .suggestion: return Color.Brand.amethyst
        case .achievement: return Color.Status.success
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: insightIcon)
                    .foregroundStyle(insightColor)
                Text(insight.title)
                    .font(.headline)
                Spacer()
                if insight.relevanceScore >= 0.8 {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.Status.warning)
                }
            }
            
            Text(insight.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var insightIcon: String {
        switch insight.type {
        case .alert: return "exclamationmark.triangle.fill"
        case .trend: return "chart.line.uptrend.xyaxis"
        case .suggestion: return "lightbulb.fill"
        case .achievement: return "star.fill"
        }
    }
}

struct PatternsSectionView: View {
    let patterns: [SpendingPattern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending Patterns")
                .font(.headline)
            
            ForEach(patterns, id: \.category) { pattern in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: pattern.category.icon)
                            .foregroundStyle(pattern.category.color)
                        Text(pattern.category.rawValue)
                            .font(.subheadline.bold())
                    }
                    
                    Text("Usually \(String(format: "%.1f", pattern.frequency)) times per month")
                        .font(.caption)
                    Text("Average amount: \(pattern.averageAmount, format: .currency(code: "USD"))")
                        .font(.caption)
                    Text("Most common: \(pattern.dayOfWeek.rawValue)s in the \(pattern.timeOfDay.rawValue)")
                        .font(.caption)
                }
                .padding()
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct PredictionsSectionView: View {
    let expenses: [Expense]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending Predictions")
                .font(.headline)
            
            // TODO: Implement actual predictions
            Text("Based on your spending patterns, we predict you'll spend approximately $1,250 next month.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
