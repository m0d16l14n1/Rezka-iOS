//
//  TitleGridComponentIpad.swift
//  HDRezka
//
//  Created by keet on 29.11.2023.
//

import SwiftUI

struct TitleGridComponentIpad: View {
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @EnvironmentObject var network: Network
    
    @Binding var page: Int
    
    @State private var startPaging = false
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(network.movies) { movie in
                NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                    TitleCardComponentIpad(model: movie)
                        .hoverEffect(.lift)
                }
                .buttonStyle(.plain)
            }
            
            if startPaging {
                Color.clear
                    .onAppear {
                        page += 1
                        print("appear")
                    }
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Task {
                    startPaging = true
                }
            }
        }
    }
}
