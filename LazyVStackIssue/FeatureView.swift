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
    @State private var offsetY: CGFloat = .zero
    
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
                
                List {
                    ForEach (1...10, id: \.self) { num in
                        Text(String(num))
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
                
                hiddenView
                
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
            .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
                print("onPreferenceChange", value)
                self.offsetY = value
            })
        }
        
    }
    
    private var hiddenView: some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetY
                )
                .onAppear { // 나타날때 뷰의 최초위치를 저장하는 로직
                    self.offsetY = offsetY
                }
        }
        .frame(height: 0)
    }
}
