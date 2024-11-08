//
//  Sample.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var offsetY: CGFloat = .zero
    
    private func hiddenView() -> some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(
                    key: ScrollPreferenceKey.self,
                    value: offsetY
                )
                .onAppear { // 나타날때 뷰의 최초위치를 저장하는 로직
                    self.offsetY = offsetY
                }
        }
        .frame(height: 0)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    hiddenView()
                    LazyVStack(spacing: 0) {
                        ForEach(0...100, id: \.self) { item in
                            ZStack() {
                                Color.gray
                                Text(String(item))
                            }
                        }
                    }
                }
            }
            .clipped()
            .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
                print(value)
                self.offsetY = value
            })
            
            Text("\(offsetY)")
                .padding()
        }
        .clipped()
    }
    
}

struct ScrollPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ContentView()
}
