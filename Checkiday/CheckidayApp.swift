//
//  CheckidayApp.swift
//  Checkiday
//
//  Created by Stigter, Leon on 11/18/24.
//

import SwiftUI

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
