//
//  YouTubePlayerViewComponent.swift
//  HDRezka
//
//  Created by keet on 15.11.2023.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubePlayerViewComponent: View {
    var youTubePlayer: YouTubePlayer

    var body: some View {
      
        YouTubePlayerView(self.youTubePlayer) { state in
            switch state {
            case .idle:
                ProgressView()
                    
            case .ready:
                EmptyView()
                    
            case .error(_):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

}

#Preview {
    YouTubePlayerViewComponent(youTubePlayer: "https://youtu.be/oeXKLVLTyCc")
}

