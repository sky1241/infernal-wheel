package com.infernal.smokingdetector.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.wear.compose.material3.ColorScheme
import androidx.wear.compose.material3.MaterialTheme
import androidx.wear.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

/**
 * Design System - Based on WEARABLE.md rules:
 * - OLED black background (#000) for battery saving
 * - Single accent color (coral red = brand)
 * - Neutral text (#E5E5E5 body, #A3A3A3 secondary)
 * - Touch targets 48dp minimum
 * - Horologist padding 26.5dp for round screens
 * - Max 2-3 lines of text per block
 */

// Brand palette - 1 primary color + neutrals (rule: 60-30-10)
val InfernalRed = Color(0xFFFF6B6B)          // Primary accent (10%)
val InfernalRedDark = Color(0xFFE05555)       // Primary pressed/container
val InfernalRedSubtle = Color(0x1AFF6B6B)     // Primary subtle bg (10% opacity)

// Semantic colors (universal standards)
val StatusSuccess = Color(0xFF4CAF50)
val StatusWarning = Color(0xFFFFC107)
val StatusError = Color(0xFFEF4444)

// Neutral scale (90% of the UI)
val SurfaceBlack = Color(0xFF000000)          // OLED background
val SurfaceDark = Color(0xFF1A1A1A)           // Elevated surfaces (cards)
val SurfaceMedium = Color(0xFF2A2A2A)         // Input/interactive surfaces
val BorderDark = Color(0xFF333333)            // Borders, dividers
val TextPrimary = Color(0xFFE5E5E5)           // Body text
val TextSecondary = Color(0xFFA3A3A3)         // Labels, metadata
val TextDisabled = Color(0xFF666666)          // Disabled state

val InfernalColorScheme = ColorScheme(
    primary = InfernalRed,
    onPrimary = Color.White,
    primaryContainer = InfernalRedDark,
    onPrimaryContainer = Color.White,
    secondary = SurfaceMedium,
    onSecondary = TextPrimary,
    secondaryContainer = SurfaceDark,
    onSecondaryContainer = TextPrimary,
    background = SurfaceBlack,
    onBackground = TextPrimary,
    surface = SurfaceBlack,
    onSurface = TextPrimary,
    surfaceContainer = SurfaceDark,
    onSurfaceVariant = TextSecondary,
    error = StatusError,
    onError = Color.White,
)

val InfernalTypography = Typography(
    // Title: screen title (18sp, medium weight)
    titleLarge = TextStyle(
        fontSize = 18.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 22.sp,
        color = TextPrimary
    ),
    // Body: main content (15sp, regular) - WEARABLE.md minimum
    bodyLarge = TextStyle(
        fontSize = 15.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 20.sp,
        color = TextPrimary
    ),
    // Label: buttons, chips, metadata (13sp, medium)
    labelLarge = TextStyle(
        fontSize = 13.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 16.sp,
        color = TextPrimary
    ),
    // Caption: secondary info, timestamps (12sp)
    bodySmall = TextStyle(
        fontSize = 12.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 16.sp,
        color = TextSecondary
    ),
    // Display: large numbers (counter)
    displayLarge = TextStyle(
        fontSize = 48.sp,
        fontWeight = FontWeight.Bold,
        lineHeight = 52.sp,
        color = TextPrimary
    ),
)

@Composable
fun InfernalWearTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = InfernalColorScheme,
        typography = InfernalTypography,
        content = content
    )
}
