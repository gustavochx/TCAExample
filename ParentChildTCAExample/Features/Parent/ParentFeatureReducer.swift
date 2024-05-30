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
        var alertContent: String?
        @Presents var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action {
        case showAlert
        case childAction(ChildFeatureReducer.Action)
        case alert(PresentationAction<AlertAction>)
        
        @CasePathable
        enum AlertAction {
            case ok
        }
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
            case .showAlert:
                state.alert = AlertState {
                    TextState("Alert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .ok) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("This is an alert")
                }
                return .none
            case .alert(.presented(.ok)):
                return .none
            default:
                return .none
            }
        }
        // Binding from the built-in alert to our state alert and same applies to the action
        .ifLet(\.$alert, action: \.alert)
    }
}
