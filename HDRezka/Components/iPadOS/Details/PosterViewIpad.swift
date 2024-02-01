//
//  PosterViewIpad.swift
//  HDRezka
//
//  Created by keet on 09.12.2023.
//

import SwiftUI

struct PosterViewIpad: View {
    @State private var isAnimated = false
    
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url), transaction: Transaction(animation: .easeInOut)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .frame(width: 311, height: 470)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.rect(cornerRadius: 11))
            } else {
                RoundedRectangle(cornerRadius: 11)
                    .frame(width: 311, height: 470)
                    .foregroundStyle(.quinary)
                    .overlay {
                        Rectangle()
                            .frame(height: 600)
                            .frame(width: 30)
                            .foregroundStyle(.quaternary)
                            .foregroundStyle(LinearGradient(colors: [ .primary, .gray ], startPoint: .top, endPoint: .bottom))
                            .rotationEffect(.degrees(30))
                            .offset(x: isAnimated ? 120 : -120)
                            .blur(radius: 15)
                    }
                    .onAppear {
                        withAnimation(.easeOut.repeatForever(autoreverses: false).speed(0.3)) {
                            isAnimated = true
                        }
                    }
            }
        }
        .clipped()
    }
}

#Preview {
    PosterViewIpad(url: "https://www.instyle.com/thmb/vZCEkHB1nBMIes2tcKTUAMP0zf0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/BarbiePosterEmbed-de7c886812184414977730e920d77a65.jpg")
}
