//
//  CollectionsMovieListViewComponentIpad.swift
//  HDRezka
//
//  Created by keet on 06.12.2023.
//

import SwiftUI

struct CollectionsMovieListViewComponentIpad: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @EnvironmentObject var collectionsParser: CollectionsParser
    
    var id: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(collectionsParser.moviesInCollections) { movie in
                    NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                        TitleCardComponentIpad(model: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                try await collectionsParser.getWatchingNowMoviesInCollection(collectionId: id, page: 1)
            }
        }
    }
}

#Preview {
    CollectionsMovieListViewComponentIpad(id: "")
        .environmentObject(CollectionsParser())
}
