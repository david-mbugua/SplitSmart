import Foundation
import SwiftData

@Model
final class SavingsChallenge: Identifiable {
    var id: UUID
    var title: String
    var targetAmount: Decimal
    var startDate: Date
    var endDate: Date
    var participants: [String]
    var creatorId: String
    var progress: [ChallengeMilestone]
    var status: ChallengeStatus
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        targetAmount: Decimal,
        startDate: Date = Date(),
        endDate: Date,
        participants: [String] = [],
        creatorId: String,
        progress: [ChallengeMilestone] = [],
        status: ChallengeStatus = .active,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.creatorId = creatorId
        self.progress = progress
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum ChallengeStatus: String, Codable {
    case active
    case completed
    case failed
}

struct ChallengeMilestone: Codable, Identifiable {
    var id: UUID
    var participantId: String
    var amount: Decimal
    var date: Date
    var note: String?
}