import SwiftUI
import VisionKit
import PhotosUI

struct ScanReceiptView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var scannerService = ReceiptScannerService.shared
    
    @State private var showingImagePicker = false
    @State private var showingDocumentScanner = false
    @State private var selectedImage: PhotosPickerItem?
    @State private var scannedReceipt: ScannedReceipt?
    @State private var isProcessing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ScanOptionsView(
                        showingDocumentScanner: $showingDocumentScanner,
                        showingImagePicker: $showingImagePicker
                    )
                    
                    if let receipt = scannedReceipt {
                        ScannedReceiptView(receipt: receipt)
                    } else if isProcessing {
                        ProgressView("Processing receipt...")
                    } else {
                        ContentUnavailableView(
                            "Scan a Receipt",
                            systemImage: "doc.text.viewfinder",
                            description: Text("Use your camera or choose a photo to scan a receipt")
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Scan Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                if scannedReceipt != nil {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create Expense") {
                            createExpenseFromReceipt()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingDocumentScanner) {
                VNDocumentCameraView { result in
                    handleScanResult(result)
                }
            }
            .photosPicker(isPresented: $showingImagePicker, selection: $selectedImage)
            .onChange(of: selectedImage) { _, newValue in
                Task {
                    await processSelectedImage(newValue)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleScanResult(_ result: Result<VNDocumentCameraScan, Error>) {
        switch result {
        case .success(let scan):
            Task {
                let images = (0..<scan.pageCount).map { scan.imageOfPage(at: $0) }
                await processScannedImages(images)
            }
        case .failure(let error):
            showError(error.localizedDescription)
        }
    }
    
    private func processScannedImages(_ images: [UIImage]) async {
        guard let firstImage = images.first,
              let imageData = firstImage.jpegData(compressionQuality: 0.8) else {
            showError("Invalid image data")
            return
        }
        
        await processReceiptImage(imageData)
    }
    
    private func processSelectedImage(_ item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await processReceiptImage(data)
            }
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    private func processReceiptImage(_ imageData: Data) async {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            scannedReceipt = try await scannerService.processReceipt(from: imageData)
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    private func createExpenseFromReceipt() {
        guard let receipt = scannedReceipt else { return }
        
        let expense = Expense(
            amount: receipt.totalAmount ?? 0,
            date: receipt.date ?? Date(),
            title: receipt.merchantName ?? "Scanned Receipt",
            category: .shopping,
            notes: "Created from scanned receipt"
        )
        
        modelContext.insert(expense)
        dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

// MARK: - Subviews
private struct ScanOptionsView: View {
    @Binding var showingDocumentScanner: Bool
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            ScanOptionButton(
                title: "Camera",
                icon: "camera.fill",
                action: { showingDocumentScanner = true }
            )
            
            ScanOptionButton(
                title: "Photo Library",
                icon: "photo.fill",
                action: { showingImagePicker = true }
            )
        }
    }
}

private struct ScannedReceiptView: View {
    let receipt: ScannedReceipt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageData = receipt.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                if let merchantName = receipt.merchantName {
                    Text(merchantName)
                        .font(.title2.bold())
                }
                
                if let date = receipt.date {
                    Text(date.formatted(date: .long, time: .omitted))
                        .foregroundStyle(.secondary)
                }
                
                if let total = receipt.totalAmount {
                    Text("Total: \((total as NSDecimalNumber) as Decimal.FormatStyle.Currency.FormatInput, format: .currency(code: "USD"))")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.Card.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if !receipt.items.isEmpty {
                ItemsListView(items: receipt.items)
            }
        }
    }
}

struct ScanOptionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.Card.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct ItemsListView: View {
    let items: [ReceiptItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items")
                .font(.headline)
            
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.description)
                            .font(.subheadline)
                        if item.quantity > 1 {
                            Text("Qty: \(item.quantity)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: "USD"))
                        .font(.subheadline.monospaced())
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct VNDocumentCameraView: UIViewControllerRepresentable {
    let completion: (Result<VNDocumentCameraScan, Error>) -> Void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let completion: (Result<VNDocumentCameraScan, Error>) -> Void
        
        init(completion: @escaping (Result<VNDocumentCameraScan, Error>) -> Void) {
            self.completion = completion
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)
            completion(.success(scan))
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
            completion(.failure(error))
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
    }
}
