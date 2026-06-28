//
//  CheckidayApp.swift
//  Checkiday
//
//  Created by Stigter, Leon on 11/18/24.
//

import SwiftUI

/// Main entry point for the Checkiday menu bar app.
/// Runs as a `MenuBarExtra` — no dock icon, no main window, just a system tray calendar icon.
@main
struct CheckidayApp: App {
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        MenuBarExtra("CheckIday", systemImage: "calendar.circle") {
            ContentView()
        }
    }
}
