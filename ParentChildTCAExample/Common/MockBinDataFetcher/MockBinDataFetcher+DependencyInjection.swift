//
//  MockBinDataFetcher+DependencyInjection.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 27/05/24.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

protocol MockBinDataFetching {
    func fetchData() async throws -> MockBinResponse
}

enum MockBinDataFetcherDependencyKey: TestDependencyKey {
    static var testValue: MockBinDataFetching {
        #if DEBUG
        return MockBinDataFetcherFailing()
        #else
        fatalError("`testValue` should not be acessed on non DEBUG builds.")
        #endif
    }
}

extension DependencyValues {
    var mockBinDataFetcher: MockBinDataFetching {
        get { self[MockBinDataFetcherDependencyKey.self] }
        set { self[MockBinDataFetcherDependencyKey.self] = newValue }
    }
}

#if DEBUG
public struct MockBinDataFetcherFailing: MockBinDataFetching {
    init() {}
    func fetchData() async throws -> MockBinResponse {
        fatalError("\(#function) should not be called")
    }
}
#endif
