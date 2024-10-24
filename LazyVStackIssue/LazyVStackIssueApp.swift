//
//  LazyVStackIssueApp.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 10/24/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct LazyVStackIssueApp: App {
    var body: some Scene {
        WindowGroup {
            FeatureView(store: Store(initialState: ImageFeature.State(), reducer: {
                ImageFeature()
            }))
        }
    }
}
