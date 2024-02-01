//
//  GradientImageView.swift
//  HDRezka
//
//  Created by keet on 14.10.2023.
//

import SwiftUI

public struct GradientImageView: View {
    @State private var isAnimated = false
    
    var url: String
    var height: CGFloat
    var blurStyle : UIBlurEffect.Style = .dark
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: url)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.quinary)
                    .overlay {
                        Rectangle()
                            .frame(height: 800)
                            .frame(width: 16)
                            .foregroundStyle(.quaternary)
                            .foregroundStyle(LinearGradient(colors: [ .primary, .gray ], startPoint: .top, endPoint: .bottom))
                            .rotationEffect(.degrees(30))
                            .offset(x: isAnimated ? 800 : -800)
                            .blur(radius: 6.0)
                            .animation(.easeInOut.repeatForever(autoreverses: false).speed(0.3), value: isAnimated)
                    }
            }
            
            VStack {}
                .frame(width: UIScreen.main.bounds.width, height: height)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: blurStyle))
                )
            
            AsyncImage(url: URL(string: url)) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(LinearGradient(stops: [ .init(color: .black, location: 0.4),
                                                  .init(color: .clear, location: 0.8),], startPoint: .top, endPoint: .bottom))
            }
        }
        .onAppear {
            withAnimation(.default) {
                isAnimated = true
            }
        }
    }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
