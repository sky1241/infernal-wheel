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
 * Design System — Harmonized palette (web + phone + watch)
 *
 * Source of truth: web dashboard CSS variables (index.html :root)
 * Watch adaptation: OLED black bg, desaturated accents per WEARABLE.md section 29
 *
 * Palette unifiee:
 * - Background: #000000 (OLED) / #0E1319 (web/phone)
 * - Surface:    #121820 / #141C25
 * - Border:     #24303C
 * - Text:       #E7EDF3 / #A7B3BF
 * - Accent:     #35D99A (brand green)
 * - Danger:     #FF7A7A / Warning: #F7BF54 / Blue: #6BBCFF
 * - Cigarette:  #E57373 (coral)
 * - Alcohol:    #FFB74D / #CE93D8 / #9575CD
 */

// Brand — green accent (unified across all platforms)
val AccentGreen = Color(0xFF35D99A)
val AccentGreenContainer = Color(0xFF0E2E1F)  // Darker, closer to bg

// Semantic — cigarette
val CigaretteColor = Color(0xFFE57373)
val CigaretteContainer = Color(0xFF2A1215)    // Subtle dark container

// Semantic — alcohol (harmonized family)
val AlcoholAmber = Color(0xFFFFB74D)           // Beer
val AlcoholWine = Color(0xFFCE93D8)            // Wine
val AlcoholStrong = Color(0xFF9575CD)          // Strong

// Status (unified with web/phone)
val StatusSuccess = Color(0xFF35D99A)          // Same as accent
val StatusError = Color(0xFFFF7A7A)            // Unified --danger

// Neutral scale — OLED optimized (watch uses true black)
val SurfaceBlack = Color(0xFF000000)           // OLED bg
val SurfaceElevated = Color(0xFF121820)        // Matches web --panel
val SurfaceMedium = Color(0xFF141C25)          // Matches web --panel-2
val BorderDark = Color(0xFF24303C)             // Matches web --border
val TextPrimary = Color(0xFFE7EDF3)            // Matches web --text
val TextSecondary = Color(0xFFA7B3BF)          // Matches web --muted
val TextDisabled = Color(0xFF6B7280)           // Matches phone muted

val InfernalColorScheme = ColorScheme(
    primary = AccentGreen,
    onPrimary = Color.Black,
    primaryContainer = AccentGreenContainer,
    onPrimaryContainer = AccentGreen,
    secondary = SurfaceMedium,
    onSecondary = TextPrimary,
    secondaryContainer = SurfaceElevated,
    onSecondaryContainer = TextPrimary,
    background = SurfaceBlack,
    onBackground = TextPrimary,
    surface = SurfaceBlack,
    onSurface = TextPrimary,
    onSurfaceVariant = TextSecondary,
    error = StatusError,
    onError = Color.White,
)

val InfernalTypography = Typography(
    titleLarge = TextStyle(
        fontSize = 18.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 22.sp,
        color = TextPrimary
    ),
    bodyLarge = TextStyle(
        fontSize = 15.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 20.sp,
        color = TextPrimary
    ),
    labelLarge = TextStyle(
        fontSize = 13.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 16.sp,
        color = TextPrimary
    ),
    bodySmall = TextStyle(
        fontSize = 12.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 16.sp,
        color = TextSecondary
    ),
    displayLarge = TextStyle(
        fontSize = 44.sp,
        fontWeight = FontWeight.Bold,
        lineHeight = 48.sp,
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
