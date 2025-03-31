import SwiftUI

struct SettlePaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var paymentService = PaymentService.shared
    
    let settlement: Settlement
    
    @State private var selectedMethod: PaymentMethod?
    @State private var isProcessing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        Text("Payment Amount")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(settlement.formattedAmount)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(Color.Brand.emerald)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Section("Payment Details") {
                    LabeledContent("From", value: settlement.from)
                    LabeledContent("To", value: settlement.to)
                }
                
                Section("Select Payment Method") {
                    ForEach(paymentService.availablePaymentMethods) { method in
                        PaymentMethodButton(
                            method: method,
                            isSelected: selectedMethod?.id == method.id,
                            action: { selectedMethod = method }
                        )
                    }
                }
                
                Section {
                    Button(action: processPayment) {
                        if isProcessing {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Send Payment")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(selectedMethod == nil || isProcessing)
                }
            }
            .navigationTitle("Settle Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert("Payment Successful", isPresented: $showingSuccess) {
                Button("Done") { dismiss() }
            } message: {
                Text("Your payment has been sent successfully.")
            }
        }
    }
    
    private func processPayment() {
        guard let method = selectedMethod else { return }
        
        isProcessing = true
        
        Task {
            do {
                let transaction = try await paymentService.processPayment(
                    amount: settlement.amount,
                    from: settlement.from,
                    to: settlement.to,
                    method: method
                )
                
                await MainActor.run {
                    if transaction.status == .completed {
                        showingSuccess = true
                    } else {
                        errorMessage = "Payment processing failed"
                        showingError = true
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
            
            await MainActor.run {
                isProcessing = false
            }
        }
    }
}

struct PaymentMethodButton: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: method.icon)
                    .foregroundStyle(method.color)
                
                Text(method.name)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.Brand.emerald)
                }
            }
            .padding(.vertical, 8)
        }
    }
}