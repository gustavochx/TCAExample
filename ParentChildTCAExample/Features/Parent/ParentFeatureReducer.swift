//
//  ParentFeatureReducer.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ParentFeatureReducer {
    
    @ObservableState
    struct State: Equatable {
        var childState: ChildFeatureReducer.State = .init()
    }
    
    enum Action: Equatable {
        case childAction(ChildFeatureReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.childState, action: \.childAction) {
            ChildFeatureReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .childAction(.decrementButtonTapped):
                guard state.childState.count < 0 else { return .none }
                
                state.childState.count = 0
                return .none
            default:
                return .none
            }
        }
    }
}
