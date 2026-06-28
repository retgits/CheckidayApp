//
//  ContentView.swift
//  Checkiday
//
//  Created by Stigter, Leon on 11/18/24.
//

import SwiftUI
import LaunchAtLogin
import CheckidayKit

/// The menu bar dropdown view displaying today's holidays.
/// Each holiday is a clickable button that opens its URL in the default browser.
struct ContentView: View {
    @StateObject private var viewModel = CheckidayViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            Text("⭐️ Loading today's holidays...")
        }
        else {
            Text("⭐️ Today's holidays are...")
        }
        
        ForEach(viewModel.checkidayData.holidays, id: \.self) { holiday in
            Button(holiday.name) {
                NSWorkspace.shared.open(holiday.url)
            }
        }
        
        Divider()
        
        Text("Last updated: \(viewModel.lastUpdatedTime.formatted(.dateTime))")
            .opacity(0.4)
        
        Divider()
        
        Button("Refresh") {
            Task {
                await viewModel.refresh()
            }
        }
        .keyboardShortcut("r")
        .disabled(viewModel.isLoading)
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
        
        Divider()
        
        LaunchAtLogin.Toggle("Launch at login")
    }
}

#if DEBUG
#Preview {
    ContentView()
        .environmentObject(CheckidayViewModel(service: CheckidayServiceMock()))
}
#endif
