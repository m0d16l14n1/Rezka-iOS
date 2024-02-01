//
//  DetailsViewRenderTest.swift
//  HDRezka
//
//  Created by keet on 16.10.2023.
//

import SwiftUI
import Alamofire
import YouTubePlayerKit

struct DetailsView: View {
    @EnvironmentObject var detailsNetwork: MovieDetailsParser
    
    var id: String
    
    var body: some View {
        NavigationStack {
            if(!detailsNetwork.movieDetailed.isEmpty) {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    ForEach(detailsNetwork.movieDetailed) { detail in
                        DetailsViewComponent(id: id, detail: detail)
                            .onAppear {
                                SharedFilmId.name = detail.nameRussian
                            }
                            .environmentObject(MovieDetailsService())
                            .onDisappear { detailsNetwork.movieDetailed.removeAll() }
                    }
                } else {
                    ForEach(detailsNetwork.movieDetailed) { detail in
                        DetailsViewComponentIpad(detail: detail, id: id)
                            .environmentObject(MovieDetailsService())
                            .onDisappear { detailsNetwork.movieDetailed.removeAll() }
                    }
                }
            } else {
                // TODO: placeholder with animation
                ProgressView(value: 0.5)
                    .progressViewStyle(.circular)
                    .onAppear { // FIXME: loading issues in first 5 secs after launch
                        AF.request(id, method: .get).responseString { response in
                            Task {
                                if let htmlString = response.value {
                                    do {
                                        try detailsNetwork.parseMovieDetails(html: htmlString, movieId: id)
                                    } catch {
                                        try detailsNetwork.parseMovieDetails(html: htmlString, movieId: id)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        SharedFilmId.id = id
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DetailsView(id: "https://hdrzk.org")
        .environmentObject(MovieDetailsParser())
}

class SharedFilmId {
    static var name = ""
    static var id = ""
}
