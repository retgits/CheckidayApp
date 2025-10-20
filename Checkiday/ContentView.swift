//
//  ContentView.swift
//  Checkiday
//
//  Created by Stigter, Leon on 11/18/24.
//

import SwiftUI
import LaunchAtLogin
import CheckidayKit

struct ContentView: View {
    @StateObject private var viewModel = CheckidayViewModel()
    
    var body: some View {
        Text("⭐️ Today's holidays are...")
        
        ForEach(viewModel.checkidayData.holidays, id: \.self) { holiday in
            Button(holiday.name) {
                if let url = URL(string: holiday.url) {
                    NSWorkspace.shared.open(url)
                }
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
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
        
        Divider()
        
        LaunchAtLogin.Toggle("Launch at login")
    }
}

#Preview {
    ContentView()
        .environmentObject(CheckidayViewModel(service: CheckidayServiceMock()))
}
