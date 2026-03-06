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
 * Settings Screen - Secondary config moved off main screen
 *
 * Rules applied:
 * - Settings in separate screen (not cluttering main - WEARABLE 9)
 * - Toggle/Split pattern for binary choices (WEARABLE 8g-bis)
 * - 48dp touch targets (WEARABLE B)
 * - ScalingLazyColumn for round screen
 */

@Composable
fun SettingsScreen(
    isLeftWrist: Boolean,
    smokingHand: String,
    onWristToggle: () -> Unit,
    onHandToggle: () -> Unit,
    onBack: () -> Unit,
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
        // -- Title --
        item {
            Text(
                text = "Reglages",
                style = InfernalTypography.titleLarge,
                color = TextPrimary,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(bottom = 8.dp)
            )
        }

        // -- Wrist setting --
        item {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Poignet",
                    style = InfernalTypography.bodySmall,
                    color = TextSecondary,
                )
                Spacer(modifier = Modifier.height(4.dp))
                OutlinedButton(
                    onClick = onWristToggle,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                ) {
                    Text(
                        text = if (isLeftWrist) "Gauche" else "Droit",
                        style = InfernalTypography.labelLarge,
                    )
                }
            }
        }

        // -- Smoking hand setting --
        item {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Main cigarette",
                    style = InfernalTypography.bodySmall,
                    color = TextSecondary,
                )
                Spacer(modifier = Modifier.height(4.dp))
                OutlinedButton(
                    onClick = onHandToggle,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                ) {
                    Text(
                        text = when (smokingHand) {
                            "left" -> "Gauche"
                            "right" -> "Droite"
                            else -> "Auto"
                        },
                        style = InfernalTypography.labelLarge,
                    )
                }
            }
        }

        // -- Back button (tertiary) --
        item {
            TextButton(
                onClick = onBack,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = "Retour",
                    style = InfernalTypography.labelLarge,
                    color = TextSecondary,
                )
            }
        }
    }
}
