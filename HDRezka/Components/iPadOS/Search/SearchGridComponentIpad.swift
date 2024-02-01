//
//  SearchGridComponentIpad.swift
//  HDRezka
//
//  Created by keet on 07.12.2023.
//

import SwiftUI

struct SearchGridComponentIpad: View {
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @EnvironmentObject var network: Network
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(network.search) { movie in
                NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                    TitleCardComponentIpad(model: movie)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}
