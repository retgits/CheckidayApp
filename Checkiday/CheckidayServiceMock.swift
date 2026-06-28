//
//  CheckidayServiceMock.swift
//  Checkiday
//
//  Created by Leon Stigter on 20/10/2025.
//

#if DEBUG
import Foundation
import CheckidayKit

/// Mock implementation of `CheckidayServiceProtocol` for SwiftUI previews and tests.
/// Returns static holiday data without making network calls.
/// Only compiled in debug builds — stripped from release.
public actor CheckidayServiceMock: CheckidayServiceProtocol {
    public init() {}

    public func fetchHolidays(for date: Date) async throws -> Checkiday {
        return Checkiday(
            error: "none",
            date: "01/01/1970",
            holidays: [
                Holiday(name: "Mock Holiday 1", url: URL(string: "https://mock.example/1")!),
                Holiday(name: "Mock Holiday 2", url: URL(string: "https://mock.example/2")!)
            ],
            number: 2,
            lastUpdate: 0
        )
    }
}
#endif
