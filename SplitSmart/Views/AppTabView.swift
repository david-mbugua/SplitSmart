import SwiftUI

struct AppTabView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        TabView {
            ExpensesView()
                .tabItem {
                    Label("Expenses", systemImage: "dollarsign.circle.fill")
                }
            
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }
            
            if premiumManager.isPremium {
                ChallengeListView()
                    .tabItem {
                        Label("Challenges", systemImage: "trophy.fill")
                    }
            }
            
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.fill")
                }
                .overlay {
                    if !premiumManager.isPremium {
                        PremiumOverlayView()
                    }
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(premiumManager)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ThemeManager())
    }
}
