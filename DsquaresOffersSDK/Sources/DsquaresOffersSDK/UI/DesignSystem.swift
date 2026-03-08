//
//  DesignSystem.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import SwiftUI

public enum DSColor {
    public static let primary = Color(hex: "E11937")
    public static let background = Color(hex: "FFFFFF")
    public static let secondaryBackground = Color(hex: "F8F9FB")
    public static let textPrimary = Color(hex: "1A1C1E")
    public static let textSecondary = Color(hex: "6C727A")
    public static let border = Color(hex: "E9ECEF")
    public static let accent = Color(hex: "FFC107")
    public static let success = Color(hex: "28A745")
    public static let surface = Color(hex: "FFFFFF")
}

public enum DSTypography {
    public static func title() -> Font { .system(size: 20, weight: .bold, design: .rounded) }
    public static func subtitle() -> Font { .system(size: 16, weight: .semibold, design: .rounded) }
    public static func body() -> Font { .system(size: 14, weight: .regular, design: .rounded) }
    public static func caption() -> Font { .system(size: 12, weight: .medium, design: .rounded) }
    public static func small() -> Font { .system(size: 10, weight: .bold, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
