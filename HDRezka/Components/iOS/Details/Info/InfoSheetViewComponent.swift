//
//  InfoSheetViewComponent.swift
//  HDRezka
//
//  Created by keet on 15.11.2023.
//

import SwiftUI
import YouTubePlayerKit

struct InfoSheetViewComponent: View {

    var detail: MovieDetailed
    var trailerLink: String?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8){
                    
                    Text(detail.nameRussian) // add maxLines
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if detail.nameOriginal != nil {
                        Text(detail.nameOriginal!) // add maxLines
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    if trailerLink != nil {
                        YouTubePlayerViewComponent(youTubePlayer: YouTubePlayer(stringLiteral: trailerLink!))
                    }
                    
                    Text(detail.description)
                        .font(.body)
                        .padding(.top, 10)
                    
                    Divider()
                    
                    Text("key_information")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        VStack(alignment: .leading) {
                            Text("key_country")
                                .font(.body)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                            Text(detail.country)
                                .font(.callout)
                                .foregroundColor(Color.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                        }
                        
                        if detail.releaseDate != nil {
                            VStack(alignment: .leading) {
                                Text("key_releasedate")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                Text(detail.releaseDate!)
                                    .font(.callout)
                                    .foregroundColor(Color.secondary)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }
                        }
                        
                        if detail.producer != nil {
                            VStack(alignment: .leading) {
                                Text("key_director")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                ForEach(detail.producer!) { directors in
                                    Text(directors.name)
                                        .font(.callout)
                                        .foregroundColor(Color.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                            }
                        }
                        
                        if detail.actors != nil {
                            VStack(alignment: .leading) {
                                Text("key_actors")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                ForEach(detail.actors!) { actors in
                                    Text(actors.name)
                                        .font(.callout)
                                        .foregroundColor(Color.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                            }
                        }
                        
                        if detail.lists != nil {
                            VStack(alignment: .leading) {
                                Text("key_lists")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                ForEach(detail.lists!) { lists in
                                    Text(lists.name)
                                        .font(.callout)
                                        .foregroundColor(Color.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("done").bold()
                        }
                    }
                }
            }
        }
    }
}

/* // TODO: make preview
#Preview {
    InfoSheetViewComponent(russianTitle: "Cool Russian Title", originalTitle: "Cool original title", trailerLink: "https://youtu.be/oeXKLVLTyCc", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", country: "Russia", releaseDate: "1.1.2011", director: [], actors: [], lists: [])
}
*/
