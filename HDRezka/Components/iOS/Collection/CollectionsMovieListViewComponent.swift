//
//  CollectionsMovieListViewComponent.swift
//  HDRezka
//
//  Created by keet on 23.11.2023.
//

import SwiftUI

struct CollectionsMovieListViewComponent: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 10)
    ]
    
    var id: String
    
    @EnvironmentObject var collectionsParser: CollectionsParser
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(collectionsParser.moviesInCollections) { movie in
                    NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                        TitleCardComponent(model: movie)
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
    CollectionsMovieListViewComponent(id: "")
        .environmentObject(CollectionsParser())
}
