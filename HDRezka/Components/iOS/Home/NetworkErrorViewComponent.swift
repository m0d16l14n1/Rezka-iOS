//
//  NetworkErrorViewComponent.swift
//  HDRezka
//
//  Created by keet on 26.12.2023.
//

import SwiftUI

struct NetworkErrorViewComponent: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "network.slash")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    
                    Text("key_networkerror")
                        .font(.footnote)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NetworkErrorViewComponent()
}
