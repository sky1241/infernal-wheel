//
//  ExtensionDelegate.swift
//  SmokingDetector WatchKit Extension
//
//  Extension delegate for handling background tasks and app lifecycle events.
//

import WatchKit

/**
 * Extension Delegate
 *
 * Handles:
 * - Background refresh tasks
 * - App lifecycle events
 * - Detection service management
 */
class ExtensionDelegate: NSObject, WKExtensionDelegate {

    // Shared detection service
    let detectionService = DetectionService()

    // MARK: - Lifecycle

    func applicationDidFinishLaunching() {
        print("[ExtensionDelegate] App finished launching")

        // Request notification permissions
        DetectionService.requestNotificationAuthorization { granted in
            print("[ExtensionDelegate] Notifications: \(granted ? "authorized" : "denied")")
        }
    }

    func applicationDidBecomeActive() {
        print("[ExtensionDelegate] App became active")
    }

    func applicationWillResignActive() {
        print("[ExtensionDelegate] App will resign active")
    }

    // MARK: - Background Tasks

    /**
     * Handle background refresh task
     *
     * Called by watchOS when background refresh fires (every 15 minutes)
     */
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let refreshTask as WKApplicationRefreshBackgroundTask:
                print("[ExtensionDelegate] Handling background refresh task")
                detectionService.handleBackgroundTask(refreshTask)

            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                print("[ExtensionDelegate] Handling snapshot task")
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)

            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                print("[ExtensionDelegate] Handling connectivity task")
                connectivityTask.setTaskCompletedWithSnapshot(false)

            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                print("[ExtensionDelegate] Handling URL session task")
                urlSessionTask.setTaskCompletedWithSnapshot(false)

            default:
                print("[ExtensionDelegate] Unknown background task: \(task)")
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}
