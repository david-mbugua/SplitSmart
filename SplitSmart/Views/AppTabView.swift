import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            ExpensesView()
                .tabItem {
                    Label("Expenses", systemImage: "creditcard.fill")
                }
            
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.2.fill")
                }
            
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ThemeManager())
    }
}