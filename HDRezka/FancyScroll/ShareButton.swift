//
//  ShareButton.swift
//  HDRezka
//
//  Created by keet on 11.12.2023.
//

import SwiftUI

struct ShareButton: View {
    let color: Color
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var detailParser: MovieDetailsParser
    
    @State private var hasBeenShownAtLeastOnce: Bool = false
    
    var body: some View {
        (presentationMode.wrappedValue.isPresented || hasBeenShownAtLeastOnce) ?
        ShareLink(item: URL(string: SharedFilmId.id)!) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 18, alignment: .leading)
                .foregroundColor(color)
                .padding(.horizontal, 18)
                .font(.system(size: 16, weight: .semibold))
                .background {
                    Circle()
                        .frame(height: 30)
                        .foregroundStyle(.ultraThinMaterial)
                }
        }
        .onAppear {
            self.hasBeenShownAtLeastOnce = true
        }
        : nil
    }
}
