//
//  RootView.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 10/27/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button {
                    path.append("feature")
                } label: {
                    Text("feature View")
                }
                
                Button {
                    path.append("normal")
                } label: {
                    Text("normal View")
                }
            }
            .navigationDestination(for: String.self) { viewName in
                if viewName == "feature" {
                    FeatureView(store: Store(initialState: ImageFeature.State(), reducer: {
                        ImageFeature()
                    }))
                } else if viewName == "normal" {
                    
                }
            }
        }
    }
    
}
