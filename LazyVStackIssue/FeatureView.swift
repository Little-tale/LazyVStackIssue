//
//  FeatureView.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 10/24/24.
//

import SwiftUI
import ComposableArchitecture

struct FeatureView: View {
    
    @Perception.Bindable var store: StoreOf<ImageFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                ScrollViewReader { proxy in // proxy
                    ZStack {
                        ZStack {
                            contentView()
                        }
                    }
                }
            }
        }
    }
}

extension FeatureView {
    
    
    private func contentView() -> some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack {
                    ForEach (Array(store.state.imageURLs.enumerated()), id: \.element.id) { index, data in
                        AsyncImage(url: data.url)
                            .frame(width: 250, height: 250)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .padding()
                            .onAppear {
                                store.send(.checkUpdate(index: index))
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
