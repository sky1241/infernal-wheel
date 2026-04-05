package com.infernal.smokingdetector.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*

/**
 * Main Screen — UX Bible WEARABLE.md rules:
 *
 * - OLED black bg, 85%+ black surface (WO-V13, section E)
 * - 48dp touch targets minimum (section B)
 * - ScalingLazyColumn for round screens (section 8c)
 * - Horologist 26.5dp responsive padding (section 8)
 * - Max 5-7 elements visible without scroll (section AW)
 * - 1 primary CTA per screen (section B)
 * - 30-40% negative space (section A)
 * - displayLarge for glanceable counter (section 9)
 *
 * Layout:
 * 1. Status dot (monitoring)
 * 2. Double counter: 🚬 X | 🍺 Y
 * 3. +1 Clope (primary red)
 * 4. +1 Biere / +1 Vin / +1 Fort (row of 3, amber)
 * 5. Reglages (text link)
 *
 * Detection auto-starts on first manual log.
 */

// Drink type colors
private val BeerColor = Color(0xFFFFC107)   // Amber
private val WineColor = Color(0xFFCE4257)   // Wine red
private val StrongColor = Color(0xFF8B5CF6) // Purple

@Composable
fun MainScreen(
    todayCount: Int,
    todayDrinkCount: Int = 0,
    totalCount: Int,
    avgPerDay: Float,
    isMonitoring: Boolean,
    lastDetection: String?,
    onLogCigarette: () -> Unit,
    onLogDrink: (String) -> Unit = {},  // type: "beer", "wine", "strong"
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
            start = 26.dp,
            end = 26.dp,
            top = 40.dp,
            bottom = 40.dp
        ),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        // -- Status dot: monitoring active/off --
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .background(
                            if (isMonitoring) StatusSuccess else TextDisabled,
                            shape = CircleShape
                        )
                )
                Spacer(modifier = Modifier.width(6.dp))
                Text(
                    text = if (isMonitoring) "Auto" else "Manuel",
                    style = InfernalTypography.bodySmall,
                    color = if (isMonitoring) StatusSuccess else TextSecondary,
                )
            }
        }

        // -- Double counter: 🚬 X   🍺 Y --
        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Cigarette counter
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "🚬",
                        fontSize = 20.sp,
                        textAlign = TextAlign.Center,
                    )
                    Text(
                        text = "$todayCount",
                        style = InfernalTypography.displayLarge,
                        color = InfernalRed,
                        textAlign = TextAlign.Center,
                    )
                }
                // Drink counter
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "🍺",
                        fontSize = 20.sp,
                        textAlign = TextAlign.Center,
                    )
                    Text(
                        text = "$todayDrinkCount",
                        style = InfernalTypography.displayLarge,
                        color = BeerColor,
                        textAlign = TextAlign.Center,
                    )
                }
            }
        }

        // -- Stats row: total + avg --
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
                        color = TextSecondary,
                    )
                }
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "${"%.1f".format(avgPerDay)}",
                        style = InfernalTypography.bodyLarge,
                        color = TextPrimary,
                    )
                    Text(
                        text = "moy/j",
                        style = InfernalTypography.bodySmall,
                        color = TextSecondary,
                    )
                }
            }
        }

        // -- Last detection feedback --
        if (lastDetection != null) {
            item {
                Text(
                    text = lastDetection,
                    style = InfernalTypography.bodySmall,
                    color = StatusSuccess,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }

        // -- ALL 4 LOG BUTTONS: 2x2 grid --
        item {
            Column(
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                // Row 1: Clope + Biere
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    Button(
                        onClick = onLogCigarette,
                        modifier = Modifier
                            .weight(1f)
                            .height(52.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = InfernalRed,
                            contentColor = Color.White,
                        ),
                    ) {
                        Text(text = "🚬", fontSize = 22.sp)
                    }
                    Button(
                        onClick = { onLogDrink("beer") },
                        modifier = Modifier
                            .weight(1f)
                            .height(52.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = BeerColor,
                            contentColor = Color.Black,
                        ),
                    ) {
                        Text(text = "🍺", fontSize = 22.sp)
                    }
                }
                // Row 2: Vin + Fort
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    Button(
                        onClick = { onLogDrink("wine") },
                        modifier = Modifier
                            .weight(1f)
                            .height(52.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = WineColor,
                            contentColor = Color.White,
                        ),
                    ) {
                        Text(text = "🍷", fontSize = 22.sp)
                    }
                    Button(
                        onClick = { onLogDrink("strong") },
                        modifier = Modifier
                            .weight(1f)
                            .height(52.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = StrongColor,
                            contentColor = Color.White,
                        ),
                    ) {
                        Text(text = "🥃", fontSize = 22.sp)
                    }
                }
            }
        }

        // -- Reglages (text link, tertiary) --
        item {
            TextButton(
                onClick = onOpenSettings,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = "Reglages",
                    style = InfernalTypography.labelLarge,
                    color = TextSecondary,
                )
            }
        }
    }
}
