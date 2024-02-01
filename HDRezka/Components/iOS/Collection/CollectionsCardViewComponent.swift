//
//  CollectionsCardViewComponent.swift
//  HDRezka
//
//  Created by keet on 22.11.2023.
//

import SwiftUI

struct CollectionsCardViewComponent: View {
    
    var collection: Collection
    
    @State private var isAnimated = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: collection.poster), transaction: Transaction(animation: .easeInOut)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 170, height: 98)
                        .scaleEffect(CGSize(width: 1.1, height: 1.1))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 170, height: 98)
                        .foregroundStyle(.quinary)
                        .overlay {
                            Rectangle()
                                .frame(height: 200)
                                .frame(width: 16)
                                .foregroundStyle(.quaternary)
                                .foregroundStyle(LinearGradient(colors: [ .primary, .gray ], startPoint: .top, endPoint: .bottom))
                                .rotationEffect(.degrees(30))
                                .offset(x: isAnimated ? 120 : -120)
                                .blur(radius: 15)
                                .animation(.easeOut.repeatForever(autoreverses: false).speed(0.2), value: isAnimated)
                        }
                        .onAppear {
                            withAnimation(.default) {
                                isAnimated = true
                            }
                        }
                }
            }
            .clipped()
            
            VStack(alignment: .leading) {
                Text(collection.name)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(2)
            }
            .frame(width: 170, height: 30, alignment: .topLeading)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CollectionsCardViewComponent(collection: Collection(id: "", name: "name", poster: "https://static.rezka.cloud/i/2023/11/9/j48ec149c6be1qk75r87c.jpg", count: 1))
}
