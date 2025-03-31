import SwiftUI
import SwiftData

struct EditGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let group: Group
    
    @State private var name: String
    @State private var members: [String]
    @State private var selectedColor: Group.GroupColor
    @State private var showingMemberSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(group: Group) {
        self.group = group
        _name = State(initialValue: group.name)
        _members = State(initialValue: group.members)
        _selectedColor = State(initialValue: Group.GroupColor(rawValue: group.color) ?? .sapphire)
    }
    
    private let minimumNameLength = 3
    
    var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        name.count >= minimumNameLength
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Information") {
                    TextField("Group Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .onChange(of: name) { oldValue, newValue in
                            name = newValue.prefix(30).description // Limit name length
                        }
                    
                    if !name.isEmpty && !isValidForm {
                        Text("Name must be at least \(minimumNameLength) characters")
                            .font(.caption)
                            .foregroundStyle(Color.Status.error)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Group.GroupColor.allCases, id: \.self) { colorOption in
                                    ColorOptionView(
                                        color: colorOption.uiColor,
                                        isSelected: selectedColor == colorOption
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedColor = colorOption
                                        }
                                    }
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
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if members.isEmpty {
                        Text("Add at least one member")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(members, id: \.self) { member in
                            HStack {
                                Text(member)
                                Spacer()
                                if member == members.first {
                                    Text("Creator")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if indexSet.contains(0) {
                                showAlert("Cannot remove the group creator")
                                return
                            }
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
                        .disabled(!isValidForm)
                }
            }
            .sheet(isPresented: $showingMemberSheet) {
                SplitMembersView(splitMembers: $members)
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveGroup() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showAlert("Group name cannot be empty")
            return
        }
        
        guard trimmedName.count >= minimumNameLength else {
            showAlert("Group name must be at least \(minimumNameLength) characters")
            return
        }
        
        group.rename(trimmedName)
        group.members = members
        group.updateColor(selectedColor)
        
        dismiss()
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

struct ColorOptionView: View {
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 30, height: 30)
            .overlay {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
            }
            .overlay {
                Circle()
                    .strokeBorder(.white, lineWidth: isSelected ? 2 : 0)
            }
            .shadow(color: color.opacity(0.3), radius: isSelected ? 4 : 0)
            .scaleEffect(isSelected ? 1.1 : 1.0)
    }
}
