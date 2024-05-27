//
//  ParentChildTCAExampleApp.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct ParentChildTCAExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ParentView(
                store: .init(
                    initialState: .init(),
                    reducer: { ParentFeatureReducer()._printChanges() }
                )
            )
        }
    }
}
