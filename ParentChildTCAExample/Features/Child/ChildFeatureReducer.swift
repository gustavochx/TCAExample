//
//  ChildFeatureReducer.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import Combine
import SwiftUI
import ComposableArchitecture

// MARK: Describe the difference between a composed Reducer and self-contained Reducer
///    Another point for reading
///         Always think about the scope of the states that will be created between the reduces
@Reducer
struct ChildFeatureReducer {
    @Dependency(\.mockBinDataFetcher) var dataFetcher
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var response: FetchingEvent<MockBinResponse, Never>?
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetTapped
        case sendRequestButtonTapped
        case requestResult(TaskResult<MockBinResponse>)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .incrementButtonTapped:
            state.count += 1
            return .none
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .resetTapped:
            state.count = 0
            return .none
        case .sendRequestButtonTapped:
            state.response = .loading
            // TODO: Create a complex asynchronous function call using do catch instead of TaskResult
            return .run { send in
                await send(
                    .requestResult(
                        TaskResult {
                            try await dataFetcher.fetchData()
                        }
                    )
                )
            }
        case let .requestResult(.success(response)):
            state.response = .success(response)
            return .none
        // TODO: Create error component
        case let .requestResult(.failure(error)):
            return .none
        }
    }
}
