//
//  HideNotchAnimatedViewComponent.swift
//  HDRezka
//
//  Created by keet on 16.01.2024.
//

import SwiftUI

struct HideNotchAnimatedViewComponent: View {
    @Binding var isAnimated: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(.black, lineWidth: 8)
                .frame(width: 300, height: 150)
                .background {
                    ZStack {
                            Rectangle()
                                .clipShape(.rect(
                                    topLeadingRadius: 25,
                                    bottomLeadingRadius: 25
                                ))
                                .frame(width: isAnimated ? 40 : 0, height: isAnimated ? 150 : 140)
                                .offset(x: isAnimated ? -135 : -146)
                                .animation(.smooth, value: isAnimated)
                            
                            Rectangle()
                                .clipShape(
                                    .rect(
                                        bottomTrailingRadius: 25,
                                        topTrailingRadius: 25
                                    )
                                )
                                .frame(width: isAnimated ? 40 : 0, height: isAnimated ? 150 : 140)
                                .offset(x: isAnimated ? 135 : 146)
                                .animation(.smooth, value: isAnimated)
                    }
                }
            
            Capsule()
                .frame(width: 17, height: 50)
                .offset(x: -130)
            
            Capsule()
                .frame(width: 3, height: 50)
                .offset(x: 140)
        }
    }
}

#Preview {
    HideNotchAnimatedViewComponent(isAnimated: .constant(false))
}
