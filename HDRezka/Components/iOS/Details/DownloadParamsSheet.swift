//
//  DownloadParamsSheet.swift
//  HDRezka
//
//  Created by keet on 13.11.2023.
//

import SwiftUI
import AlertKit

struct DownloadParamsSheet: View {
    var id: String
    var voiceActing: [MovieVoiceActing]?
    
    @State var seasons: [MovieSeason]?
    @State private var selectedActing = MovieVoiceActing(id: "", name: "", translatorId: "", isCamrip: "", isAds: "", isDirector: "", isSelected: false)
    @State private var selectedSeason = MovieSeason(id: "", name: "", episodes: [], isSelected: false)
    @State private var selectedEpisode = MovieEpisode(id: "", name: "", isSelected: false)
    
    @EnvironmentObject var detailService: MovieDetailsService
    @StateObject var downloadManager: DownloadViewModel
    
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
                }
                
                Section {
                    ProgressView(value: Double(String(format: "%.3f", downloadManager.progress))) {
                        Text("Progress")
                    }
                    .progressViewStyle(.linear)
                }
                
                Section {
                    Button {
                        Task {
                            if seasons != nil {
                                let video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: selectedSeason, episode: selectedEpisode, id: id)
                                downloadManager.downloadVideo(url: URL(string: video._720p!)!)
                            } else {
                                let video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: nil, episode: nil, id: id)
                                downloadManager.downloadVideo(url: URL(string: video._720p!)!)
                            }
                        }
                    } label: {
                        Label("Download", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.borderless)
                    
                    Button {
                        Task {
                            if seasons != nil {
                                let video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: selectedSeason, episode: selectedEpisode, id: id)
                                UIPasteboard.general.string = video._1080pUltra
                                AlertKitAPI.present(title: String(localized: "key_copied"), icon: .done, style: .iOS17AppleMusic, haptic: .success)
                            } else {
                                let video = try await detailService.getMovieVideo(voiceActing: selectedActing, season: nil, episode: nil, id: id)
                                UIPasteboard.general.string = video._1080pUltra
                                AlertKitAPI.present(title: String(localized: "key_copied"), icon: .done, style: .iOS17AppleMusic, haptic: .success)
                            }
                        }
                    } label: {
                        Label("key_copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.borderless)
                    
                    Label("Данная функция является тестовой и не работает в фоне. Видео может загружаться очень долго", systemImage: "exclamationmark.circle")
                        .bold()
                }
            }
        }
        .onAppear {
            selectedActing = voiceActing!.first!
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
            }
        }
    }
}
