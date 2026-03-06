package com.infernal.smokingdetector.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*

/**
 * Main Screen - Simplified UX per WEARABLE.md rules:
 *
 * Layout (ScalingLazyColumn for round screen):
 * 1. Counter display (big number, primary focus)
 * 2. Status indicator (monitoring on/off)
 * 3. Primary CTA: "+1 Cigarette" (manual log)
 * 4. Secondary: Start/Stop Monitor toggle
 * 5. Tertiary: Open on Phone + Settings
 *
 * Rules applied:
 * - 1 CTA primary per screen (WEARABLE B, MOBILE CS)
 * - Touch targets 48dp minimum (WEARABLE B)
 * - Max 5-7 elements visible without scroll (WEARABLE AW)
 * - ScalingLazyColumn not LazyColumn (WEARABLE 8c)
 * - Horologist responsive padding for round screen
 * - OLED black background (WEARABLE E)
 */

@Composable
fun MainScreen(
    todayCount: Int,
    totalCount: Int,
    avgPerDay: Float,
    isMonitoring: Boolean,
    lastDetection: String?,
    onLogCigarette: () -> Unit,
    onToggleMonitor: () -> Unit,
    onOpenSettings: () -> Unit,
    onOpenOnPhone: () -> Unit,
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
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        // -- Counter: today's count (primary info, glanceable) --
        item {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(bottom = 4.dp)
            ) {
                Text(
                    text = "$todayCount",
                    style = InfernalTypography.displayLarge,
                    color = InfernalRed,
                    textAlign = TextAlign.Center,
                )
                Text(
                    text = "aujourd'hui",
                    style = InfernalTypography.bodySmall,
                    color = TextSecondary,
                    textAlign = TextAlign.Center,
                )
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
                        text = "moy/jour",
                        style = InfernalTypography.bodySmall,
                        color = TextSecondary,
                    )
                }
            }
        }

        // -- Monitoring status indicator --
        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .background(
                            if (isMonitoring) StatusSuccess else TextDisabled,
                            shape = androidx.compose.foundation.shape.CircleShape
                        )
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = if (isMonitoring) "Detection active" else "Detection off",
                    style = InfernalTypography.bodySmall,
                    color = if (isMonitoring) StatusSuccess else TextSecondary,
                )
            }
        }

        // -- Last detection info (if any) --
        if (lastDetection != null) {
            item {
                Text(
                    text = lastDetection,
                    style = InfernalTypography.bodySmall,
                    color = StatusWarning,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }

        // -- PRIMARY CTA: Log cigarette (1 seul bouton primary par ecran) --
        item {
            Button(
                onClick = onLogCigarette,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = InfernalRed,
                    contentColor = androidx.compose.ui.graphics.Color.White,
                ),
            ) {
                Text(
                    text = "+1 Cigarette",
                    style = InfernalTypography.labelLarge,
                    color = androidx.compose.ui.graphics.Color.White,
                )
            }
        }

        // -- SECONDARY: Toggle monitoring (outlined = secondary hierarchy) --
        item {
            OutlinedButton(
                onClick = onToggleMonitor,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = if (isMonitoring) "Stop Detection" else "Demarrer Detection",
                    style = InfernalTypography.labelLarge,
                )
            }
        }

        // -- TERTIARY: Open on phone via Bluetooth --
        item {
            TextButton(
                onClick = onOpenOnPhone,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = "Voir sur le tel",
                    style = InfernalTypography.labelLarge,
                    color = TextSecondary,
                )
            }
        }

        // -- TERTIARY: Settings --
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
