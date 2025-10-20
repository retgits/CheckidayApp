//
//  CheckidayTests.swift
//  CheckidayTests
//
//  Created by Leon Stigter on 20/10/2025.
//

import XCTest
@testable import CheckidayKit
@testable import Checkiday

struct CheckidayTests {

    final class CheckidayAppTests: XCTestCase {

        @MainActor
        func testViewModelRefreshUpdatesData() async throws {
            let mockService = CheckidayServiceMock()
            
            let viewModel = CheckidayViewModel(service: mockService)
            
            XCTAssertTrue(viewModel.checkidayData.holidays.isEmpty)
            
            await viewModel.refresh()
            
            XCTAssertEqual(viewModel.checkidayData.holidays.count, 2)
            XCTAssertEqual(viewModel.checkidayData.holidays.first?.name, "Mock Holiday 1")
        }
    }

}
