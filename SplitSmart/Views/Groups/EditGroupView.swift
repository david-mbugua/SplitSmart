import SwiftUI
import SwiftData

struct EditGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let group: Group
    @State private var name: String
    @State private var members: [String]
    @State private var selectedColor: String
    @State private var showingMemberSheet = false
    
    init(group: Group) {
        self.group = group
        _name = State(initialValue: group.name)
        _members = State(initialValue: group.members)
        _selectedColor = State(initialValue: group.color)
    }
    
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
            .navigationTitle("Edit Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveGroup() }
                        .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingMemberSheet) {
                SplitMembersView(splitMembers: $members)
            }
        }
    }
    
    private func saveGroup() {
        group.name = name
        group.members = members
        group.color = selectedColor
        group.updatedAt = Date()
        dismiss()
    }
}