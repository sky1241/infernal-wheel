//
//  ContentView.swift
//  SmokingDetector WatchKit App
//
//  Main UI for Apple Watch smoking detection app.
//  Displays detection status, cigarette count, and control buttons.
//

import SwiftUI

/**
 * Main Content View
 *
 * Features:
 * - Start/Stop monitoring button
 * - Real-time cigarette count display
 * - Last detection timestamp
 * - Status indicator (monitoring/stopped)
 * - Reset counter button
 */
struct ContentView: View {

    // MARK: - State

    @State private var isMonitoring = false
    @State private var cigaretteCount = 0
    @State private var lastDetectionTime: Date?
    @State private var statusMessage = "Ready"

    // Detection service (shared instance)
    private let detectionService = DetectionService()

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Status indicator
                statusIndicator

                // Cigarette count
                cigaretteCountView

                // Last detection time
                if let lastTime = lastDetectionTime {
                    lastDetectionView(time: lastTime)
                }

                // Start/Stop button
                startStopButton

                // Reset button
                if cigaretteCount > 0 {
                    resetButton
                }
            }
            .padding()
        }
        .onAppear {
            // Request notification permissions
            DetectionService.requestNotificationAuthorization { granted in
                if !granted {
                    statusMessage = "⚠️ Notifications disabled"
                }
            }
        }
    }

    // MARK: - Subviews

    private var statusIndicator: some View {
        HStack {
            Circle()
                .fill(isMonitoring ? Color.green : Color.gray)
                .frame(width: 12, height: 12)

            Text(statusMessage)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var cigaretteCountView: some View {
        VStack(spacing: 4) {
            Text("🚬")
                .font(.system(size: 50))

            Text("\(cigaretteCount)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("cigarettes detected")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }

    private func lastDetectionView(time: Date) -> some View {
        VStack(spacing: 4) {
            Text("Last detection")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(timeAgoString(from: time))
                .font(.caption)
                .foregroundColor(.orange)
        }
    }

    private var startStopButton: some View {
        Button(action: toggleMonitoring) {
            HStack {
                Image(systemName: isMonitoring ? "stop.fill" : "play.fill")
                    .font(.system(size: 18))

                Text(isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isMonitoring ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var resetButton: some View {
        Button(action: resetCounter) {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14))

                Text("Reset Counter")
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.2))
            .foregroundColor(.secondary)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Actions

    private func toggleMonitoring() {
        if isMonitoring {
            // Stop monitoring
            detectionService.stop()
            isMonitoring = false
            statusMessage = "Stopped"
        } else {
            // Start monitoring
            statusMessage = "Starting..."
            detectionService.start { success in
                isMonitoring = success
                statusMessage = success ? "Monitoring" : "Error"
            }
        }
    }

    private func resetCounter() {
        detectionService.resetCounter()
        cigaretteCount = 0
        lastDetectionTime = nil
        statusMessage = "Counter reset"
    }

    private func updateStats() {
        cigaretteCount = detectionService.getTotalCount()
        lastDetectionTime = detectionService.getLastDetectionTime()
    }

    // MARK: - Helpers

    private func timeAgoString(from date: Date) -> String {
        let seconds = Int(-date.timeIntervalSinceNow)

        if seconds < 60 {
            return "\(seconds)s ago"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let days = seconds / 86400
            return "\(days)d ago"
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
