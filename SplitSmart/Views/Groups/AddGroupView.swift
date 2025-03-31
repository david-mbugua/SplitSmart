import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var members: [String] = []
    @State private var selectedColor = "sapphire"
    @State private var showingMemberSheet = false
    
    let colorOptions = [
        ("sapphire", Color.Brand.sapphire),
        ("emerald", Color.Brand.emerald),
        ("amethyst", Color.Brand.amethyst),
        ("ruby", Color.Brand.ruby)
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Information") {
                    TextField("Group Name", text: $name)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                        HStack(spacing: 12) {
                            ForEach(colorOptions, id: \.0) { colorName, color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        if colorName == selectedColor {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .onTapGesture {
                                        selectedColor = colorName
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Members") {
                    Button(action: { showingMemberSheet.toggle() }) {
                        HStack {
                            Text("Add Members")
                            Spacer()
                            Text("\(members.count) members")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if !members.isEmpty {
                        ForEach(members, id: \.self) { member in
                            Text(member)
                        }
                        .onDelete { indexSet in
                            members.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { saveGroup() }
                        .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingMemberSheet) {
                SplitMembersView(splitMembers: $members)
            }
        }
    }
    
    private func saveGroup() {
        let group = Group(
            name: name,
            members: members,
            color: selectedColor
        )
        modelContext.insert(group)
        dismiss()
    }
}