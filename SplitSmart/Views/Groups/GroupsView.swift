import SwiftUI
import SwiftData

struct GroupsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Group.createdAt, order: .reverse) private var groups: [Group]
    @State private var showingAddGroup = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groups) { group in
                    NavigationLink(destination: GroupDetailView(group: group)) {
                        GroupRowView(group: group)
                    }
                }
                .onDelete(perform: deleteGroups)
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddGroup.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView()
            }
        }
    }
    
    private func deleteGroups(offsets: IndexSet) {
        withAnimation {
            offsets.map { groups[$0] }.forEach(modelContext.delete)
        }
    }
}

struct GroupRowView: View {
    let group: Group
    
    private var groupColor: Color {
        switch group.color {
        case "sapphire": return Color.Brand.sapphire
        case "emerald": return Color.Brand.emerald
        case "amethyst": return Color.Brand.amethyst
        case "ruby": return Color.Brand.ruby
        default: return Color.Brand.sapphire
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(groupColor)
                .frame(width: 24, height: 24)
                .overlay {
                    Image(systemName: "person.3.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                Text("\(group.members.count) members")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(group.expenses.count) expenses")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
