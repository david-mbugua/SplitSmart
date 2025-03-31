import Foundation
import SwiftData
import VisionKit

@Model
final class ScannedReceipt {
    var id: UUID
    var imageData: Data?
    var merchantName: String?
    var totalAmount: Decimal?
    var date: Date?
    var items: [ReceiptItem]
    var processingStatus: ProcessingStatus
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        merchantName: String? = nil,
        totalAmount: Decimal? = nil,
        date: Date? = nil,
        items: [ReceiptItem] = [],
        processingStatus: ProcessingStatus = .pending,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.imageData = imageData
        self.merchantName = merchantName
        self.totalAmount = totalAmount
        self.date = date
        self.items = items
        self.processingStatus = processingStatus
        self.createdAt = createdAt
    }
    
    enum ProcessingStatus: String, Codable {
        case pending
        case processing
        case completed
        case failed
    }
}

struct ReceiptItem: Codable, Identifiable {
    let id: UUID
    var description: String
    var amount: Decimal
    var quantity: Int
    var assignedTo: [String]
}