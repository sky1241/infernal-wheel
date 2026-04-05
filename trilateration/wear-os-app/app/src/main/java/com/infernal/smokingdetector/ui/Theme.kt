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
 * Design System — WEARABLE.md bible rules:
 *
 * Colors (section 29):
 * - OLED black #000000 background (pixels off = 0 power)
 * - Desaturated vs mobile (small screen = perceived brighter)
 * - Max 4-5 colors total (section 29b)
 * - Contrast 4.5:1 text, 3:1 UI minimum
 * - 60-30-10 rule: 60% black, 30% neutral, 10% accent
 *
 * Typography (section 14):
 * - Min 12sp body text
 * - Max 2-3 lines per block
 * - Display for glanceable counters
 *
 * Layout (section B, 8):
 * - 48dp touch targets minimum
 * - Horologist 26.5dp padding
 * - Card min 52dp height, 24dp radius
 */

// Brand — green accent (matches phone app #35D99A, desaturated for OLED)
val AccentGreen = Color(0xFF35D99A)            // Primary brand (phone match)
val AccentGreenDim = Color(0xFF2AAF7E)         // Dimmed variant
val AccentGreenContainer = Color(0xFF1A3D2E)   // Container bg

// Semantic — cigarette (warm coral, not pure red for OLED)
val CigaretteColor = Color(0xFFE57373)         // Desaturated coral
val CigaretteContainer = Color(0xFF3D1A1A)     // Dark container

// Semantic — alcohol types (one hue family, desaturated)
val AlcoholAmber = Color(0xFFFFB74D)           // Beer — warm amber
val AlcoholWine = Color(0xFFCE93D8)            // Wine — soft purple-pink
val AlcoholStrong = Color(0xFF9575CD)          // Strong — medium purple

// Status (universal, desaturated for OLED)
val StatusSuccess = Color(0xFF66BB6A)          // Green
val StatusWarning = Color(0xFFFFB74D)          // Amber
val StatusError = Color(0xFFEF5350)            // Red

// Neutral scale (90% of the UI — section 29: 60% black, 30% neutral)
val SurfaceBlack = Color(0xFF000000)           // OLED background
val SurfaceDark = Color(0xFF121212)            // Elevation 0
val SurfaceElevated = Color(0xFF1E1E1E)        // Elevation 1 — cards
val SurfaceMedium = Color(0xFF272727)          // Elevation 4 — interactive
val BorderDark = Color(0xFF333333)             // Borders
val TextPrimary = Color(0xFFE0E0E0)            // Body text (#E0E0E0 per bible)
val TextSecondary = Color(0xFF9E9E9E)          // Labels (#9E9E9E per bible)
val TextDisabled = Color(0xFF616161)           // Disabled

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
    // Title: screen header (18sp, medium — section 14)
    titleLarge = TextStyle(
        fontSize = 18.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 22.sp,
        color = TextPrimary
    ),
    // Body: main content (15sp — section 14: min 12sp)
    bodyLarge = TextStyle(
        fontSize = 15.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 20.sp,
        color = TextPrimary
    ),
    // Label: buttons, chips (13sp, medium)
    labelLarge = TextStyle(
        fontSize = 13.sp,
        fontWeight = FontWeight.Medium,
        lineHeight = 16.sp,
        color = TextPrimary
    ),
    // Caption: secondary info (12sp — minimum per bible)
    bodySmall = TextStyle(
        fontSize = 12.sp,
        fontWeight = FontWeight.Normal,
        lineHeight = 16.sp,
        color = TextSecondary
    ),
    // Display: large counter numbers (glanceable — section 9)
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
