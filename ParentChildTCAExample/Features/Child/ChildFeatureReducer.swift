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
        var response: FetchingEvent<MockBinResponse, Never> = .none
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetTapped
        case sendRequestButtonTapped
        case responseReceived(MockBinResponse?)
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
            return .run { send in
                let returnedResponse = try? await dataFetcher.fetchData()
                await send(.responseReceived(returnedResponse))
            }
        case let .responseReceived(response):
            // TODO: Discuss with Bocato if is this the right approach to handle with error
            guard let returnedResponse = response else { return .none }
            
            state.response = .success(returnedResponse)
            return .none
        }
    }
}

