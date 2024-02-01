//
//  TitleCardComponent.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI

struct TitleCardComponent: View {
    var model: MovieSimple
    
    @State private var isAnimated = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: model.poster), transaction: Transaction(animation: .easeInOut)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 113, height: 171)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 113, height: 171)
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
                Text(model.name)
                    .font(.system(size: 12, weight: .bold))
                    .lineLimit(2)
                Text(model.details)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 112, height: 44, alignment: .topLeading)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    TitleCardComponent(model: MovieSimple(id: "1", name: "sometestname", details: "sometestdetails", poster: "somepath"))
}
