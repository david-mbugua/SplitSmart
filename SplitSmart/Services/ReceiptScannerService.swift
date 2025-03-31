import Foundation
import Vision
import VisionKit
import SwiftUI

class ReceiptScannerService: ObservableObject {
    static let shared = ReceiptScannerService()
    
    private let queue = DispatchQueue(label: "com.splitsmart.receiptscan")
    
    private init() {}
    
    func processReceipt(from imageData: Data) async throws -> ScannedReceipt {
        guard let image = UIImage(data: imageData),
              let cgImage = image.cgImage else {
            throw ReceiptScanError.invalidImage
        }
        
        let receipt = ScannedReceipt(imageData: imageData)
        
        do {
            receipt.processingStatus = .processing
            
            // Perform text recognition
            let requestHandler = VNImageRequestHandler(cgImage: cgImage)
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            try requestHandler.perform([request])
            
            guard let observations = request.results else {
                throw ReceiptScanError.noTextFound
            }
            
            // Process recognized text
            var items: [ReceiptItem] = []
            var totalAmount: Decimal?
            var merchantName: String?
            var date: Date?
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }
            
            // Process each line of text
            for line in recognizedText {
                if merchantName == nil {
                    // Usually the merchant name is at the top of the receipt
                    merchantName = line
                    continue
                }
                
                if date == nil {
                    // Look for date patterns
                    if let extractedDate = extractDate(from: line) {
                        date = extractedDate
                        continue
                    }
                }
                
                // Look for items with prices
                if let (description, amount) = extractItemAndPrice(from: line) {
                    items.append(ReceiptItem(
                        id: UUID(),
                        description: description,
                        amount: amount,
                        quantity: 1,
                        assignedTo: []
                    ))
                    continue
                }
                
                // Look for total amount
                if line.lowercased().contains("total") {
                    if let amount = extractAmount(from: line) {
                        totalAmount = amount
                    }
                }
            }
            
            // Update receipt with extracted information
            receipt.merchantName = merchantName
            receipt.totalAmount = totalAmount
            receipt.date = date
            receipt.items = items
            receipt.processingStatus = .completed
            
            return receipt
        } catch {
            receipt.processingStatus = .failed
            throw error
        }
    }
    
    private func extractDate(from text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Add more date format patterns as needed
        let patterns = [
            "\\d{2}/\\d{2}/\\d{4}",
            "\\d{2}-\\d{2}-\\d{4}"
        ]
        
        for pattern in patterns {
            if let range = text.range(of: pattern, options: .regularExpression) {
                let dateStr = String(text[range])
                if let date = dateFormatter.date(from: dateStr) {
                    return date
                }
            }
        }
        
        return nil
    }
    
    private func extractItemAndPrice(from text: String) -> (String, Decimal)? {
        // Look for patterns like "Item name $XX.XX"
        let pattern = "(.+)\\s+\\$?(\\d+\\.\\d{2})"
        
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) else {
            return nil
        }
        
        let nsString = text as NSString
        let descriptionRange = match.range(at: 1)
        let amountRange = match.range(at: 2)
        
        let description = nsString.substring(with: descriptionRange)
        let amountString = nsString.substring(with: amountRange)
        
        guard let amount = Decimal(string: amountString) else {
            return nil
        }
        
        return (description.trimmingCharacters(in: .whitespaces), amount)
    }
    
    private func extractAmount(from text: String) -> Decimal? {
        let pattern = "\\$?(\\d+\\.\\d{2})"
        
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) else {
            return nil
        }
        
        let nsString = text as NSString
        let amountRange = match.range(at: 1)
        let amountString = nsString.substring(with: amountRange)
        
        return Decimal(string: amountString)
    }
}

enum ReceiptScanError: Error {
    case invalidImage
    case noTextFound
}
