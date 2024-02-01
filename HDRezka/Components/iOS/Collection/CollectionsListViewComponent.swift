//
//  CollectionCardViewComponent.swift
//  HDRezka
//
//  Created by keet on 21.11.2023.
//

import SwiftUI

struct CollectionsListViewComponent: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    @EnvironmentObject var collectionsParser: CollectionsParser
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(collectionsParser.collections, id: \.name) { collection in // identifiable?
                        NavigationLink(destination: CollectionsMovieListViewComponent(id: collection.id)        .environmentObject(CollectionsParser())) {
                            CollectionsCardViewComponent(collection: collection)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .navigationTitle("key_collections")
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            Task {
                try await collectionsParser.getCollections(page: 1)
            }
        }
    }
}

#Preview {
    CollectionsListViewComponent()
        .environmentObject(CollectionsParser())
}
