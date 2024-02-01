//
//  VideoSelectSheetsViewComponent.swift
//  HDRezka
//
//  Created by keet on 02.11.2023.
//

import SwiftUI

struct VideoParamsSheet: View {
    var id: String
    var voiceActing: [MovieVoiceActing]?
    
    @State var seasons: [MovieSeason]?
    @State private var selectedActing = MovieVoiceActing(id: "", name: "", translatorId: "", isCamrip: "", isAds: "", isDirector: "", isSelected: false)
    @State private var selectedSeason = MovieSeason(id: "", name: "", episodes: [], isSelected: false)
    @State private var selectedEpisode = MovieEpisode(id: "", name: "", isSelected: false)
    
    @Binding var video: String
    @Binding var isPresentedPlayer: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var detailService: MovieDetailsService
    
    var body: some View {
        VStack {
            Form {
                Section {
                    if seasons != nil {
                        Picker("episode", selection: $selectedEpisode) {
                            ForEach(selectedSeason.episodes, id: \.self) { episode in
                                Text(episode.name).tag(episode)
                            }
                        }
                        
                        Picker("season", selection: $selectedSeason) {
                            ForEach(seasons!, id: \.name) { season in
                                Text(season.name).tag(season)
                            }
                        }
                    }
                    
                    Picker("voice acting", selection: $selectedActing) {
                        ForEach(voiceActing!, id: \.name) { acting in
                            Text(acting.name).tag(acting)
                        }
                    }
                    
                    // TODO: quality
                }
                
                Section {
                    Button {
                        Task {
                            if seasons != nil {
                                video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: selectedSeason, episode: selectedEpisode, id: id)._1080p!
                                isPresentedPlayer.toggle()
                            } else {
                                video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: nil, episode: nil, id: id)._1080p!
                                isPresentedPlayer.toggle()
                            }
                        }
                    } label: {
                        Text("key_watch")
                            .font(.headline)
                            .frame(maxWidth: UIScreen.main.bounds.width/1.2, maxHeight: 20)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .onAppear {
            if let index = voiceActing?.firstIndex(where: { $0.isSelected }) {
                selectedActing = voiceActing![index]
            } else {
                selectedActing = voiceActing!.first!
            }
        }
        .onAppear {
            if seasons != nil {
                selectedSeason = seasons!.first!
                selectedEpisode = selectedSeason.episodes.first!
            }
        }
        .onChange(of: selectedActing) {
            Task {
                try await seasons = detailService.getSeriesSeasons(movieId: id, voiceActing: selectedActing)
                
                if seasons != nil {
                    selectedSeason = seasons!.first!
                }
            }
        }
    }
}
