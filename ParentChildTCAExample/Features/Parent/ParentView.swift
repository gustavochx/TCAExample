//
//  ParentView.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct ParentView: View {
    let store: StoreOf<ParentFeatureReducer>
    
    var body: some View {
        VStack {
            ChildView(
                store: store.scope(
                    state: \.childState,
                    action: \.childAction
                )
            )
        }
    }
}
