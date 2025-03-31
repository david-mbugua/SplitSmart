import SwiftUI

struct PaymentSettingsView: View {
    @StateObject private var paymentService = PaymentService.shared
    @State private var showingLinkAccount = false
    @State private var selectedMethod: PaymentMethod?
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        List {
            Section("Linked Accounts") {
                ForEach(paymentService.linkedAccounts) { account in
                    if let method = paymentService.availablePaymentMethods.first(where: { $0.id == account.methodId }) {
                        HStack {
                            Image(systemName: method.icon)
                                .foregroundStyle(method.color)
                            
                            VStack(alignment: .leading) {
                                Text(method.name)
                                    .font(.headline)
                                Text(account.accountIdentifier)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if account.isVerified {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
                
                Button(action: { showingLinkAccount = true }) {
                    Label("Link New Account", systemImage: "plus")
                }
            }
            
            Section("Available Payment Methods") {
                ForEach(paymentService.availablePaymentMethods) { method in
                    HStack {
                        Image(systemName: method.icon)
                            .foregroundStyle(method.color)
                        Text(method.name)
                        Spacer()
                        if method.isAvailable {
                            Text("Available")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Payment Methods")
        .sheet(isPresented: $showingLinkAccount) {
            LinkAccountView()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct LinkAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var paymentService = PaymentService.shared
    @State private var selectedMethod: PaymentMethod?
    @State private var email = ""
    @State private var isLinking = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Payment Method", selection: $selectedMethod) {
                        Text("Select a method").tag(nil as PaymentMethod?)
                        ForEach(paymentService.availablePaymentMethods) { method in
                            Label(method.name, systemImage: method.icon)
                                .foregroundStyle(method.color)
                                .tag(method as PaymentMethod?)
                        }
                    }
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }
                
                Section {
                    Button(action: linkAccount) {
                        if isLinking {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Link Account")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(selectedMethod == nil || email.isEmpty || isLinking)
                }
            }
            .navigationTitle("Link Account")
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
        }
    }
    
    private func linkAccount() {
        guard let method = selectedMethod else { return }
        
        isLinking = true
        
        Task {
            do {
                _ = try await paymentService.linkAccount(method: method)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
            
            await MainActor.run {
                isLinking = false
            }
        }
    }
}