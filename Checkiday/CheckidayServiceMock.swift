//
//  CheckidayServiceMock.swift
//  Checkiday
//
//  Created by Leon Stigter on 20/10/2025.
//


import Foundation
import CheckidayKit

public actor CheckidayServiceMock: CheckidayServiceProtocol {
    public init() {}

    public func fetchHolidays(for date: Date) async throws -> Checkiday {
        return Checkiday(
            error: "none",
            date: "01/01/1970",
            holidays: [
                Holiday(name: "Mock Holiday 1", url: "https://mock.example/1"),
                Holiday(name: "Mock Holiday 2", url: "https://mock.example/2")
            ],
            number: 2,
            lastUpdate: 0
        )
    }
}
