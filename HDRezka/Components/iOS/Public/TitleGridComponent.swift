//
//  TitleGridComponent.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI

struct TitleGridComponent: View {
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 10)
    ]
    
    @EnvironmentObject var network: Network
    
    @Binding var page: Int
    
    @State private var startPaging = false
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(network.movies) { movie in
                NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                    TitleCardComponent(model: movie)
                }
                .buttonStyle(.plain)
            }
            
            if startPaging {
                Color.clear
                    .onAppear {
                        page += 1
                    }
            }
        }
        .padding()
        .onLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Task {
                    startPaging = true
                }
            }
        }
    }
}
