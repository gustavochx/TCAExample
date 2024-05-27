//
//  ChildView.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

struct ChildView: View {
    let store: StoreOf<ChildFeatureReducer>
    
    var body: some View {
        ZStack {
            Color
                .black
                .opacity(store.state.response.isLoading ? 0.5 : 0.0)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(store.state.response.isLoading ? 1 : 0)
            
            mainContentView
        }
        .ignoresSafeArea()
    }
    
    var mainContentView: some View {
        VStack {
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(String(store.count))
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        store.send(.resetTapped)
                    }
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button("Send request") {
                store.send(.sendRequestButtonTapped)
            }
            .font(.title)
            .padding()
            .background(Color.blue.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(store.state.response.value ?? "")
                .font(.headline)
                .foregroundColor(Color.blue)
                .padding(.top, 20.0)
        }
    }
}
