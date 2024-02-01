//
//  CollectionsListViewComponentIpad.swift
//  HDRezka
//
//  Created by keet on 06.12.2023.
//

import SwiftUI

struct CollectionsListViewComponentIpad: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @EnvironmentObject var collectionsParser: CollectionsParser
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(collectionsParser.collections, id: \.name) { collection in // identifiable?
                        NavigationLink(destination: CollectionsMovieListViewComponentIpad(id: collection.id)        .environmentObject(CollectionsParser())) {
                            CollectionsCardViewComponentIpad(collection: collection)
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
    CollectionsListViewComponentIpad()
        .environmentObject(CollectionsParser())
}
