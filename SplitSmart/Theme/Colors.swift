import SwiftUI

// MARK: - Custom Color Extensions
extension Color {
    struct Brand {
        static let sapphire = Color("Sapphire")
        static let amethyst = Color("Amethyst")
        static let emerald = Color("Emerald")
        static let ruby = Color("Ruby")
    }
    
    struct Background {
        static let primary = Color("BackgroundPrimary")
        static let secondary = Color("BackgroundSecondary")
        static let tertiary = Color("BackgroundTertiary")
    }
    
    struct Text {
        static let primary = Color("TextPrimary")
        static let secondary = Color("TextSecondary")
        static let tertiary = Color("TextTertiary")
    }
    
    struct Status {
        static let success = Color("Success")
        static let warning = Color("Warning")
        static let error = Color("Error")
    }
    
    struct Card {
        static let background = Color("CardBackground")
        static let border = Color("CardBorder")
    }
}

struct SplitSmartGradients {
    static let primaryGradient = LinearGradient(
        colors: [Color.Brand.sapphire, Color.Brand.amethyst],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color.Brand.emerald, Color.Brand.sapphire],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
