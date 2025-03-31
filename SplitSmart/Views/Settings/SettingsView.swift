import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $themeManager.selectedTheme) {
                        ForEach(ThemeMode.allCases, id: \.self) { theme in
                            Text(theme.displayName)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}