//
//  ParentView.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct ParentView: View {
    @Bindable var store: StoreOf<ParentFeatureReducer>
    
    var body: some View {
        VStack {
            ChildView(
                store: store.scope(
                    state: \.childState,
                    action: \.childAction
                )
            )
            
            Button(action: {
                store.send(.showAlert)
            }, label: {
                Text("Present alert")
            })
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
