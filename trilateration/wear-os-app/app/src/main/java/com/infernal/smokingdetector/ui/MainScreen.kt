package com.infernal.smokingdetector.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*

/**
 * Main Screen — WEARABLE.md bible UX rules applied:
 *
 * Section A: 30-40% negative space, content in safe zone
 * Section B: 48dp touch targets, 1 primary CTA
 * Section E: OLED black, desaturated colors
 * Section 8: ScalingLazyColumn, 26.5dp Horologist padding
 * Section 9: Glanceable counter (displayLarge)
 * Section 14: Min 12sp text
 * Section 29: Max 4-5 colors, 60-30-10 rule
 * Section 29b: Daltonism safe (emoji + color, not color alone)
 * Card: min 52dp height, 24dp radius (section 8 components)
 */

@Composable
fun MainScreen(
    todayCount: Int,
    todayDrinkCount: Int = 0,
    totalCount: Int,
    avgPerDay: Float,
    isMonitoring: Boolean,
    lastDetection: String?,
    onLogCigarette: () -> Unit,
    onLogDrink: (String) -> Unit = {},
    onToggleMonitor: () -> Unit,
    onOpenSettings: () -> Unit,
) {
    val listState = rememberScalingLazyListState()

    ScalingLazyColumn(
        state = listState,
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceBlack),
        horizontalAlignment = Alignment.CenterHorizontally,
        contentPadding = PaddingValues(
            start = 26.dp,  // Horologist 26.5dp
            end = 26.dp,
            top = 40.dp,
            bottom = 40.dp
        ),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        // ── Status indicator ──
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(6.dp)
                        .background(
                            if (isMonitoring) StatusSuccess else TextDisabled,
                            shape = CircleShape
                        )
                )
                Spacer(modifier = Modifier.width(6.dp))
                Text(
                    text = if (isMonitoring) "Detection auto" else "Manuel",
                    style = InfernalTypography.bodySmall,
                    color = if (isMonitoring) StatusSuccess else TextSecondary,
                )
            }
        }

        // ── Glanceable counters (card style, elevated surface) ──
        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(24.dp))
                    .background(SurfaceElevated)
                    .padding(vertical = 16.dp, horizontal = 12.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "$todayCount",
                        style = InfernalTypography.displayLarge,
                        color = CigaretteColor,
                    )
                    Text(
                        text = "🚬",
                        fontSize = 16.sp,
                    )
                }

                // Subtle divider
                Box(
                    modifier = Modifier
                        .width(1.dp)
                        .height(40.dp)
                        .background(BorderDark)
                )

                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "$todayDrinkCount",
                        style = InfernalTypography.displayLarge,
                        color = AlcoholAmber,
                    )
                    Text(
                        text = "🍺",
                        fontSize = 16.sp,
                    )
                }
            }
        }

        // ── Stats row (muted, secondary info) ──
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "$totalCount",
                        style = InfernalTypography.bodyLarge,
                        color = TextPrimary,
                    )
                    Text(
                        text = "total",
                        style = InfernalTypography.bodySmall,
                    )
                }
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "${"%.1f".format(avgPerDay)}/j",
                        style = InfernalTypography.bodyLarge,
                        color = TextPrimary,
                    )
                    Text(
                        text = "moyenne",
                        style = InfernalTypography.bodySmall,
                    )
                }
            }
        }

        // ── Feedback toast ──
        if (lastDetection != null) {
            item {
                Text(
                    text = lastDetection,
                    style = InfernalTypography.bodySmall,
                    color = AccentGreen,
                    textAlign = TextAlign.Center,
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(AccentGreenContainer)
                        .padding(vertical = 6.dp)
                )
            }
        }

        // ── Log cigarette (primary CTA — section B: 1 primary per screen) ──
        item {
            Button(
                onClick = onLogCigarette,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(52.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = CigaretteContainer,
                    contentColor = CigaretteColor,
                ),
                shape = RoundedCornerShape(24.dp),
            ) {
                Text(text = "🚬  +1", fontSize = 18.sp, color = CigaretteColor)
            }
        }

        // ── Log drinks (2x2 grid, 48dp min touch targets) ──
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
                // Beer
                Button(
                    onClick = { onLogDrink("beer") },
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = SurfaceElevated,
                        contentColor = AlcoholAmber,
                    ),
                    shape = RoundedCornerShape(16.dp),
                ) {
                    Text(text = "🍺", fontSize = 20.sp)
                }
                // Wine
                Button(
                    onClick = { onLogDrink("wine") },
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = SurfaceElevated,
                        contentColor = AlcoholWine,
                    ),
                    shape = RoundedCornerShape(16.dp),
                ) {
                    Text(text = "🍷", fontSize = 20.sp)
                }
                // Strong
                Button(
                    onClick = { onLogDrink("strong") },
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = SurfaceElevated,
                        contentColor = AlcoholStrong,
                    ),
                    shape = RoundedCornerShape(16.dp),
                ) {
                    Text(text = "🥃", fontSize = 20.sp)
                }
            }
        }

        // ── Settings (tertiary, text only) ──
        item {
            TextButton(
                onClick = onOpenSettings,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = "⚙ Reglages",
                    style = InfernalTypography.labelLarge,
                    color = TextSecondary,
                )
            }
        }
    }
}
