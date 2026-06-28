//
//  UserNotifications.swift
//  Checkiday
//
//  Created by Leon Stigter on 3/7/25.
//

import UserNotifications

/// Requests notification permission on app launch.
/// Called once during `CheckidayApp.init()` to prompt the user for alert/sound/badge access.
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Error requesting permission: \(error.localizedDescription)")
        } else if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}

/// Displays an immediate macOS notification with the given title and message.
/// Used to surface API errors or network failures to the user.
func showMacNotification(title: String, message: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
    content.sound = UNNotificationSound.default

    let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: nil
    )

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error showing notification: \(error.localizedDescription)")
        }
    }
}
