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
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var response: Event<String, Never> = .none
    }
    
    enum Event<Success: Equatable, Error: Equatable>: Equatable {
        case none
        case success(Success)
        case error(Error)
        case loading
        
        var isLoading: Bool {
            self == .loading
        }
        
        var value: Success? {
            switch self {
            case let .success(success):
                return success
            default:
                return nil
            }
        }
    }
    
    var dependency: SenpaiClient = .init()
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetTapped
        case sendRequestButtonTapped
        case responseReceived(String)
    }
    
    struct SenpaiClient {
        func callRequest() async -> String {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            return UUID().uuidString
        }
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
                let returnedResponse = await dependency.callRequest()
                await send(.responseReceived(returnedResponse))
            }
        case let .responseReceived(response):
            state.response = .success(response)
            return .none
        }
    }
}

