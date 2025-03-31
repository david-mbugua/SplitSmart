import SwiftUI

// MARK: - Card Modifier
struct CardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
            .shadow(
                color: colorScheme == .dark ? .black.opacity(0.3) : .gray.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Button Modifiers
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(SplitSmartGradients.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .sapphire.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct SecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.backgroundSecondary)
            .foregroundColor(.textPrimary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
    }
}

// MARK: - Typography Modifiers
struct HeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.title, design: .rounded, weight: .bold))
            .foregroundColor(.textPrimary)
    }
}

struct SubheadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.title3, design: .rounded, weight: .semibold))
            .foregroundColor(.textSecondary)
    }
}

struct BodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded))
            .foregroundColor(.textPrimary)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func primaryButton() -> some View {
        modifier(PrimaryButtonStyle())
    }
    
    func secondaryButton() -> some View {
        modifier(SecondaryButtonStyle())
    }
    
    func headingStyle() -> some View {
        modifier(HeadingStyle())
    }
    
    func subheadingStyle() -> some View {
        modifier(SubheadingStyle())
    }
    
    func bodyStyle() -> some View {
        modifier(BodyStyle())
    }
}