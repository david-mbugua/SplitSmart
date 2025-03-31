import SwiftUI

enum ThemeMode: String, CaseIterable {
    case dark, light, system
    
    var displayName: String {
        rawValue.capitalized
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var themeString: String = ThemeMode.dark.rawValue
    @Published var selectedTheme: ThemeMode
    @Published var colorScheme: ColorScheme = .dark
    
    init() {
        selectedTheme = .dark
        if let storedTheme = ThemeMode(rawValue: themeString) {
            selectedTheme = storedTheme
        }
        updateColorScheme()
    }
    
    func setTheme(_ theme: ThemeMode) {
        selectedTheme = theme
        updateColorScheme()
    }
    
    func updateColorScheme() {
        switch selectedTheme {
        case .dark:
            colorScheme = .dark
        case .light:
            colorScheme = .light
        case .system:
            colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        }
    }
}

extension ColorScheme {
    static var current: ColorScheme {
        UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
}
