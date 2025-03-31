import SwiftUI
import SwiftData
import Charts

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [Expense]
    @State private var selectedTab = 0
    
    var viewModel: ReportsViewModel {
        ReportsViewModel(expenses: expenses)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    SpendingSummaryView(viewModel: viewModel)
                    
                    // Charts TabView
                    TabView(selection: $selectedTab) {
                        CategoryChartView(viewModel: viewModel)
                            .tag(0)
                        
                        TrendsChartView(viewModel: viewModel)
                            .tag(1)
                    }
                    .tabViewStyle(.page)
                    .frame(height: 400)
                    
                    // Tab Indicators
                    HStack {
                        ForEach(0..<2) { index in
                            Circle()
                                .fill(selectedTab == index ? Color.Brand.sapphire : .gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Reports")
        }
    }
}

struct SpendingSummaryView: View {
    let viewModel: ReportsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                SummaryCard(
                    title: "Total Spending",
                    value: viewModel.totalSpending,
                    format: .currency(code: "USD"),
                    icon: "creditcard.fill",
                    color: .Brand.sapphire
                )
                
                SummaryCard(
                    title: "Average Expense",
                    value: viewModel.averageExpenseAmount,
                    format: .currency(code: "USD"),
                    icon: "chart.bar.fill",
                    color: .Brand.emerald
                )
            }
            
            if let (category, amount) = viewModel.mostExpensiveCategory {
                SummaryCard(
                    title: "Top Category",
                    subtitle: category.rawValue,
                    value: amount,
                    format: .currency(code: "USD"),
                    icon: category.icon,
                    color: category.color
                )
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    var subtitle: String? = nil
    let value: Decimal
    let format: FloatingPointFormatStyle<Double>.Currency
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            if let subtitle {
                Text(subtitle)
                    .font(.headline)
            }
            
            Text(NSDecimalNumber(decimal: value).doubleValue, format: format)
                .font(.title2.bold())
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CategoryChartView: View {
    let viewModel: ReportsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending by Category")
                .font(.headline)
            
            Chart {
                ForEach(viewModel.categorySpending) { category in
                    SectorMark(
                        angle: .value("Spending", category.percentage),
                        innerRadius: .ratio(0.6),
                        angularInset: 1
                    )
                    .foregroundStyle(category.category.color)
                    .cornerRadius(4)
                    .annotation(position: .overlay) {
                        Text(String(format: "%.0f%%", category.percentage * 100))
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(height: 200)
            
            // Legend
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.categorySpending) { category in
                    HStack {
                        Circle()
                            .fill(category.category.color)
                            .frame(width: 8, height: 8)
                        Text(category.category.rawValue)
                            .font(.subheadline)
                        Spacer()
                        Text(category.amount, format: .currency(code: "USD"))
                            .font(.subheadline.bold())
                    }
                }
            }
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TrendsChartView: View {
    let viewModel: ReportsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Trends")
                .font(.headline)
            
            Chart {
                ForEach(viewModel.monthlySpending) { month in
                    BarMark(
                        x: .value("Month", month.month, unit: .month),
                        y: .value("Amount", NSDecimalNumber(decimal: month.amount).doubleValue)
                    )
                    .foregroundStyle(Color.Brand.sapphire.gradient)
                    .cornerRadius(4)
                }
                
                RuleMark(
                    y: .value("Average", NSDecimalNumber(decimal: viewModel.averageExpenseAmount).doubleValue)
                )
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .foregroundStyle(Color.Brand.ruby)
                .annotation(position: .top, alignment: .leading) {
                    Text("Average")
                        .font(.caption)
                        .foregroundStyle(Color.Brand.ruby)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisValueLabel(format: .dateTime.month(.narrow))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 200)
            
            // Trend indicator
            HStack {
                Image(systemName: viewModel.spendingTrend > 0 ? "arrow.up.right" : "arrow.down.right")
                Text("\(abs(viewModel.spendingTrend * 100), specifier: "%.1f")% \(viewModel.spendingTrend > 0 ? "increase" : "decrease")")
                Text("from last month")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            .foregroundStyle(viewModel.spendingTrend > 0 ? Color.Status.error : Color.Status.success)
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
