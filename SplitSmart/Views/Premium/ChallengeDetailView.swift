import SwiftUI
import SwiftData

struct ChallengeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let challenge: SavingsChallenge
    
    var progress: Double {
        let totalSaved = challenge.progress.reduce(0) { $0 + $1.amount }
        return NSDecimalNumber(decimal: totalSaved / challenge.targetAmount).doubleValue
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Challenge Header
                VStack(spacing: 12) {
                    Text(challenge.title)
                        .font(.title2.bold())
                    
                    Text(challenge.targetAmount as Decimal, format: .currency(code: "USD"))
                        .font(.title.bold())
                        .foregroundStyle(Color.Brand.emerald)
                    
                    ProgressView(value: progress)
                        .tint(Color.Brand.emerald)
                    
                    Text("\(Int(progress * 100))% Complete")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Participants
                VStack(alignment: .leading, spacing: 12) {
                    Text("Participants")
                        .font(.headline)
                    
                    ForEach(challenge.participants, id: \.self) { participant in
                        HStack {
                            Text(participant)
                            Spacer()
                            let amount = participantProgress(for: participant)
                            Text(amount, format: .currency(code: "USD"))
                                .foregroundStyle(amount > 0 ? Color.Brand.emerald : .secondary)
                        }
                    }
                }
                .padding()
                .background(Color.Card.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Progress Timeline
                if !challenge.progress.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Progress")
                            .font(.headline)
                        
                        ForEach(challenge.progress.sorted(by: { $0.date > $1.date })) { milestone in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(milestone.participantId)
                                        .font(.subheadline.bold())
                                    Text(milestone.date, format: .dateTime.month().day())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(milestone.amount, format: .currency(code: "USD"))
                                    .foregroundStyle(Color.Brand.emerald)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color.Card.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .navigationTitle("Challenge Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func participantProgress(for participant: String) -> Decimal {
        challenge.progress
            .filter { $0.participantId == participant }
            .reduce(0) { $0 + $1.amount }
    }
}
