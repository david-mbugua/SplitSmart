import SwiftUI

extension Color {
    // Primary Brand Colors
    static let sapphire = Color("Sapphire")
    static let amethyst = Color("Amethyst")
    static let emerald = Color("Emerald")
    static let ruby = Color("Ruby")
    
    // Background Colors
    static let backgroundPrimary = Color("BackgroundPrimary")
    static let backgroundSecondary = Color("BackgroundSecondary")
    static let backgroundTertiary = Color("BackgroundTertiary")
    
    // Text Colors
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textTertiary = Color("TextTertiary")
    
    // Status Colors
    static let success = Color("Success")
    static let warning = Color("Warning")
    static let error = Color("Error")
    
    // Card Colors
    static let cardBackground = Color("CardBackground")
    static let cardBorder = Color("CardBorder")
}

struct SplitSmartGradients {
    static let primaryGradient = LinearGradient(
        colors: [.sapphire, .amethyst],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [.emerald, .sapphire],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}