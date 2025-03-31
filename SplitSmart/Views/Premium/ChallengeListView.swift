import SwiftUI
import SwiftData

struct ChallengeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var challenges: [SavingsChallenge]
    @State private var showingNewChallenge = false
    
    var body: some View {
        List {
            Section {
                ForEach(challenges) { challenge in
                    NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                        ChallengeCellView(challenge: challenge)
                    }
                }
            }
        }
        .navigationTitle("Savings Challenges")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingNewChallenge.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewChallenge) {
            NewChallengeView()
        }
    }
}

struct ChallengeCellView: View {
    let challenge: SavingsChallenge
    
    var progress: Double {
        let totalSaved = challenge.progress.reduce(0) { $0 + $1.amount }
        return NSDecimalNumber(decimal: totalSaved / challenge.targetAmount).doubleValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(challenge.title)
                .font(.headline)
            
            HStack {
                Text(challenge.targetAmount, format: .currency(code: "USD"))
                    .font(.subheadline.bold())
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .foregroundStyle(progress >= 1 ? Color.Status.success : .secondary)
            }
            
            ProgressView(value: progress)
                .tint(Color.Brand.emerald)
            
            Text("\(challenge.participants.count) participants")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
