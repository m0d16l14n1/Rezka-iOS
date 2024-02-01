//
//  SearchGridComponent.swift
//  HDRezka
//
//  Created by keet on 01.10.2023.
//

import SwiftUI

struct SearchGridComponent: View {
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 10)
    ]
    
    @EnvironmentObject var network: Network
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(network.search) { movie in
                NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                    TitleCardComponent(model: movie)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
