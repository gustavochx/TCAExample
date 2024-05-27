//
//  MockBinDataFetcher.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 27/05/24.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

struct MockBinResponse: Decodable, Equatable {
    var message: String
}

enum MockBinAPIErrors: Error {
    case decodingError(DecodingError)
    case invalidUrl(String)
    case serverError(String)
}

final class MockBinDataFetcher: MockBinDataFetching {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(
        urlSession: URLSession,
        jsonDecoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    convenience init() {
        self.init(urlSession: Self.makeDefaultSession(), jsonDecoder: .init())
    }
    
    private static func makeDefaultSession() -> URLSession {
        let defaultSessionConfiguration: URLSessionConfiguration = .default
        defaultSessionConfiguration.urlCache = .shared
        let defaultUrlSession = URLSession(
            configuration: defaultSessionConfiguration
        )
        return defaultUrlSession
    }
    
    func fetchData() async throws -> MockBinResponse {
        let endpoint = "https://af140aff58454c5191b5b7913cef1eff.api.mockbin.io/"
        guard let url = URL(string: endpoint) else {
            throw MockBinAPIErrors.invalidUrl(endpoint)
        }
        do {
            let urlRequest = URLRequest(url: url)
            let (data, _) = try await urlSession.data(for: urlRequest)
            let fetchedData = try jsonDecoder.decode(MockBinResponse.self, from: data)
            return fetchedData
        } catch let decodingError as DecodingError {
            throw MockBinAPIErrors.decodingError(decodingError)
        } catch {
            throw MockBinAPIErrors.serverError(error.localizedDescription)
        }
    }
}

extension MockBinDataFetcherDependencyKey: DependencyKey {
    public static var liveValue: MockBinDataFetching {
        return MockBinDataFetcher()
    }
}
