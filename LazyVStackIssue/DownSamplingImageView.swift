//
//  DownSamplingImageView.swift
//  LazyVStackIssue
//
//  Created by Jae hyung Kim on 10/24/24.
//

import SwiftUI
import Kingfisher

struct DownSamplingImageView: View {
    
    @State private var currentURL: URL? = nil
    
    let url: URL?
    let option: Option
    var fallbackURL: URL? = nil
    
    enum Option {
        case max
        case mid
        case min
        case custom(CGSize)
        
        var size: CGSize {
            return switch self {
            case .max:
                CGSize(width: 300, height: 300)
            case .mid:
                CGSize(width: 200, height: 200)
            case .min:
                CGSize(width: 100, height: 100)
            case let .custom(size):
                size
            }
        }
    }
    
    var body: some View {
        if currentURL != nil {
            KFImage(currentURL)
                .setProcessor(
                    DownsamplingImageProcessor(
                        size: option.size
                    )
                )
                .onFailure { error in
                    #if DEBUG
                    print(error)
                    #endif
                    if case .imageSettingError(reason: .emptySource) = error {
                        currentURL = url
                    } else if let fallbackURL {
                        currentURL = fallbackURL
                    }
                }
                .loadDiskFileSynchronously(false) // 동기적 디스크 호출 안함
                .cancelOnDisappear(true) // 사라지면 취소
                .cacheOriginalImage(false)
                .diskCacheExpiration(.expired) // 디스크 캐시 만료 즉시 설정
                .memoryCacheExpiration(.expired)
                .backgroundDecode(true) // 백그라운드에서 디코딩
                .fade(duration: 0.38)
                .retry(maxCount: 2, interval: .seconds(1))
                .resizable()
        } else {
            Color.clear
                .onAppear {
                    currentURL = url ?? fallbackURL
                }
        }
    }
}
