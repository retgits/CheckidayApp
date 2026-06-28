//
//  CheckidayViewModel.swift
//  Checkiday
//
//  Created by Leon Stigter on 20/10/2025.
//

import Foundation
import SwiftUI
import CheckidayKit

/// Drives the menu bar UI by fetching and caching holiday data.
///
/// On init, loads the last cached response from UserDefaults for instant display,
/// then starts an hourly background refresh cycle. Failed fetches preserve
/// the cached data rather than showing an empty state.
@MainActor
class CheckidayViewModel: ObservableObject {

    @Published var checkidayData: Checkiday
    @Published var isLoading = false
    @Published var lastUpdatedTime: Date

    private let service: CheckidayServiceProtocol
    private var refreshTask: Task<Void, Never>?

    init(service: CheckidayServiceProtocol = CheckidayService()) {
        self.service = service
        self.checkidayData = Checkiday(
            error: "none",
            date: Date.now.formatted(),
            holidays: [],
            number: 0,
            lastUpdate: Date.now.hashValue
        )
        self.lastUpdatedTime = Date.now
        
        // Load cached data for immediate display before the first network call
        if let cached = UserDefaults.standard.data(forKey: "cachedCheckiday"),
           let decoded = try? JSONDecoder().decode(Checkiday.self, from: cached) {
                self.checkidayData = decoded
        }
        
        startAutoRefresh()
    }
    
    deinit {
        refreshTask?.cancel()
    }

    /// Fetches today's holidays from the API and updates the UI.
    /// On success, caches the response to UserDefaults.
    /// On failure, preserves existing cached data and shows a notification.
    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        
        lastUpdatedTime = Date.now
        do {
            let result = try await service.fetchHolidays(for: Date.now)
            self.checkidayData = result
            
            if !result.isSuccess {
                showMacNotification(title: "Error updating Checkiday app", message: result.error)
            }
            
            if result.isSuccess {
                let encoded = try? JSONEncoder().encode(result)
                UserDefaults.standard.set(encoded, forKey: "cachedCheckiday")
            }
            
        } catch {
            if checkidayData.holidays.isEmpty {
                      self.checkidayData = Checkiday(
                          error: "Unexpected error: \(error.localizedDescription)",
                          date: Date.now.formatted(),
                          holidays: [],
                          number: 0,
                          lastUpdate: Date.now.hashValue
                      )
                  }
            else {
                self.checkidayData.error = "Unexpected error: \(error.localizedDescription)"
            }
            showMacNotification(title: "Error updating Checkiday app", message: error.localizedDescription)
        }
    }
    
    /// Starts an hourly refresh loop. Fetches immediately on first run,
    /// then sleeps for 3600 seconds between subsequent fetches.
    private func startAutoRefresh() {
        refreshTask = Task {
            while !Task.isCancelled {
                await refresh()
                try? await Task.sleep(for: .seconds(3600))
            }
        }
    }
}
