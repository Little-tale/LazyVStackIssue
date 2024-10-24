//
//  ImageFeature.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 10/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ImageFeature {
    
    @ObservableState
    struct State: Equatable {
        var imageURLs: [URLModel] = []
        var updateTrigger = true
        let testStruct = TestStruct()
    }
    
    struct TestStruct: Equatable {
        let test = "TEst"
        let hello = "HELLO"
        let fine = "FINE"
        let thx = "THANKS"
    }
    
    enum Action {
        case onAppear
        case checkUpdate(index: Int)
        case updateURL
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.updateURL)
                
            case let .checkUpdate(index):
                if state.updateTrigger {
                    if index > state.imageURLs.count - 4 {
                        state.updateTrigger = false
                        return .send(.updateURL)
                    }
                }
                return .none
            case .updateURL:
                let url = URL(string:"https://picsum.photos/250/250")!
                let urls = (0..<20).map { _ in URLModel(url: url) }
                state.imageURLs.append(contentsOf: urls)
                state.updateTrigger = true
                return .none
            }
        }
    }
}
