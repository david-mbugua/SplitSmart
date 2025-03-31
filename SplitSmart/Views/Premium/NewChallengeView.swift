import SwiftUI
import SwiftData

struct NewChallengeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var targetAmount = 0.0
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 days from now
    @State private var participants: [String] = []
    @State private var showingParticipantSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Challenge Details") {
                    TextField("Challenge Title", text: $title)
                    
                    HStack {
                        Text("$")
                        TextField("Target Amount", value: $targetAmount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date])
                }
                
                Section("Participants") {
                    Button(action: { showingParticipantSheet.toggle() }) {
                        HStack {
                            Text("Add Participants")
                            Spacer()
                            Text("\(participants.count) people")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !participants.isEmpty {
                        ForEach(participants, id: \.self) { participant in
                            Text(participant)
                        }
                        .onDelete { indexSet in
                            participants.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("New Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createChallenge() }
                        .disabled(title.isEmpty || targetAmount == 0 || participants.isEmpty)
                }
            }
            .sheet(isPresented: $showingParticipantSheet) {
                SplitMembersView(splitMembers: $participants)
            }
        }
    }
    
    private func createChallenge() {
        let challenge = SavingsChallenge(
            title: title,
            targetAmount: Decimal(targetAmount),
            startDate: startDate,
            endDate: endDate,
            participants: participants,
            creatorId: participants.first ?? ""
        )
        
        modelContext.insert(challenge)
        dismiss()
    }
}