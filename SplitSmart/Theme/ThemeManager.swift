import SwiftUI

enum ThemeMode: String, CaseIterable {
    case dark, light, system
    
    var displayName: String {
        rawValue.capitalized
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedTheme: ThemeMode = .dark
    @Published var colorScheme: ColorScheme = .dark
    
    init() {
        updateColorScheme()
    }
    
    func setTheme(_ theme: ThemeMode) {
        selectedTheme = theme
        updateColorScheme()
    }
    
    private func updateColorScheme() {
        switch selectedTheme {
        case .dark:
            colorScheme = .dark
        case .light:
            colorScheme = .light
        case .system:
            colorScheme = .current
        }
    }
}

private extension ColorScheme {
    static var current: ColorScheme {
        UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
}