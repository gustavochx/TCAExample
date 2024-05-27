//
//  Event.swift
//  ParentChildTCAExample
//
//  Created by Gustavo Soares on 27/05/24.
//

import Foundation

// MARK: Similar implementation than a Triple
enum FetchingEvent<Success: Equatable, Error: Equatable>: Equatable {
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
