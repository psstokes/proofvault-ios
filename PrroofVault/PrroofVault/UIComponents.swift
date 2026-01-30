//
//  UIComponents.swift
//  PrroofVault
//
//  Created by Codex on 2026-01-28.
//

import SwiftUI

enum AppSpacing {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let section: CGFloat = 24
}

enum AppRadius {
    static let card: CGFloat = 20
    static let button: CGFloat = 18
    static let chip: CGFloat = 14
}

enum AppTypography {
    static let title = Font.system(size: 30, weight: .bold, design: .rounded)
    static let subtitle = Font.system(size: 16, weight: .regular)
    static let cardTitle = Font.system(size: 18, weight: .semibold)
    static let body = Font.system(size: 16, weight: .regular)
    static let caption = Font.system(size: 13, weight: .regular)
}

enum AppTheme {
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let accent = Color.accentColor
    static let divider = Color(.separator)
}

struct AppStrings {
    static let vaultTitle = "Vault"
    static let vaultSubtitle = "A calm record of what you own."
    static let addItem = "Add Item"
    static let addYourFirstItem = "Add your first item"
}

struct CardSurface<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
                    .fill(AppTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
                            .strokeBorder(
                                Color.white.opacity(colorScheme == .dark ? 0.08 : 0.2),
                                lineWidth: 0.5
                            )
                    )
                    .shadow(
                        color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.08),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
            )
    }
}

struct PrimaryButton: View {
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(isDisabled ? Color(.systemGray4) : AppTheme.accent)
                .foregroundStyle(isDisabled ? Color(.systemGray) : Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous))
        }
        .disabled(isDisabled)
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppTheme.primaryText)
            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
    }
}

struct StatusChip: View {
    let title: String
    var style: ChipStyle = .neutral

    enum ChipStyle {
        case neutral
        case positive
        case warning
    }

    private var backgroundColor: Color {
        switch style {
        case .neutral:
            return Color(.secondarySystemBackground)
        case .positive:
            return Color.green.opacity(0.18)
        case .warning:
            return Color.orange.opacity(0.2)
        }
    }

    private var textColor: Color {
        switch style {
        case .neutral:
            return AppTheme.secondaryText
        case .positive:
            return Color.green
        case .warning:
            return Color.orange
        }
    }

    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.chip, style: .continuous)
                    .fill(backgroundColor)
            )
    }
}
