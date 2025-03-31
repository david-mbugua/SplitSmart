import SwiftUI

struct SplitMembersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var splitMembers: [String]
    @State private var newMember = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Add person", text: $newMember)
                        Button("Add") {
                            withAnimation {
                                if !newMember.isEmpty {
                                    splitMembers.append(newMember)
                                    newMember = ""
                                }
                            }
                        }
                        .disabled(newMember.isEmpty)
                    }
                }
                
                Section {
                    ForEach(splitMembers, id: \.self) { member in
                        Text(member)
                    }
                    .onDelete { indexSet in
                        splitMembers.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Split with")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}