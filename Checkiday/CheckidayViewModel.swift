//
//  CheckidayViewModel.swift
//  Checkiday
//
//  Created by Leon Stigter on 20/10/2025.
//


import Foundation
import SwiftUI
import CheckidayKit

@MainActor
class CheckidayViewModel: ObservableObject {

    @Published var checkidayData: Checkiday
    @Published var lastUpdatedTime: Date

    private let service: CheckidayServiceProtocol
    private var timer: Timer?

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
        
        startAutoRefresh()
    }
    
    deinit {
        timer?.invalidate()
    }

    func refresh() async {
        lastUpdatedTime = Date.now
        do {
            let result = try await service.fetchHolidays(for: Date.now)
            self.checkidayData = result
            if result.error != "none" {
                showMacNotification(title: "Error updating Checkiday app", message: result.error)
            }
        } catch {
            self.checkidayData = Checkiday(
                error: "Unexpected error: \(error.localizedDescription)",
                date: Date.now.formatted(),
                holidays: [],
                number: 0,
                lastUpdate: Date.now.hashValue
            )
            showMacNotification(title: "Error updating Checkiday app", message: error.localizedDescription)
        }
    }
    
    private func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refresh()
            }
        }
    }
}
