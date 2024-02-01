//
//  DetailsViewComponentIpad.swift
//  HDRezka
//
//  Created by keet on 07.12.2023.
//

import SwiftUI

struct DetailsViewComponentIpad: View {
    
    var detail: MovieDetailed
    
    var id: String
    
    @State private var isPresentedScheduleSheet = false
    @State private var isPresentedPlaySheet = false
    @State private var isPresentedDownloadSheet = false
    @State private var isPresentedMoreSheet = false
    @State private var isPresentedPlayer = false
    @State private var video = ""
    
    @State private var width = UIScreen.main.bounds.width
    
    @State private var link: String? = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        PosterViewIpad(url: detail.poster)
                        
                        VStack {
                            Spacer()
                            
                            Group {
                                Text(detail.nameRussian)
                                    .font(.largeTitle)
                                    .bold()
                                    .lineLimit(2)
                                
                                ForEach(detail.genres[0...0]) { genre in
                                    Text("\(genre.name) • \(detail.releaseDate ?? "unknown") • \(detail.country)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                
                                if detail.availability == Availability.AVAILABLE_ON_REZKA && !detail.comingSoon {
                                    HStack {
                                        Button {
                                            isPresentedPlaySheet.toggle()
                                        } label: {
                                            Label("key_watch", systemImage: "play.fill")
                                                .font(.system(size: 18))
                                                .foregroundStyle(.red)
                                        }
                                        .hoverEffect(.highlight)
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.capsule)
                                        .sheet(isPresented: $isPresentedPlaySheet) {
                                            VideoParamsSheet(id: id, voiceActing: detail.voiceActing, seasons: detail.seasons, video: $video, isPresentedPlayer: $isPresentedPlayer)
                                                .environmentObject(MovieDetailsService())
                                                .presentationDragIndicator(.visible)
                                                .presentationDetents([.medium])
                                        }
                                        .navigationDestination(isPresented: $isPresentedPlayer) {
                                            PlayerViewComponent(url: video)
                                        }
                                        
                                        Button {
                                            isPresentedDownloadSheet.toggle()
                                        } label: {
                                            Label("Download", systemImage: "arrow.down.circle")
                                                .font(.system(size: 18))
                                                .foregroundStyle(.red)
                                                .labelStyle(.iconOnly)
                                        }
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.circle)
                                        .sheet(isPresented: $isPresentedDownloadSheet) {
                                            DownloadParamsSheet(id: id, voiceActing: detail.voiceActing, seasons: detail.seasons, downloadManager: DownloadViewModel())
                                                .environmentObject(MovieDetailsService())
                                                .environmentObject(DownloadViewModel())
                                                .presentationDragIndicator(.visible)
                                                .presentationDetents([.medium, .large])
                                        }
                                        
                                        Button {
                                            isPresentedMoreSheet.toggle()
                                        } label: {
                                            Label("key_more", systemImage: "ellipsis.circle")
                                                .font(.system(size: 18))
                                                .foregroundStyle(.red)
                                                .labelStyle(.iconOnly)
                                        }
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.circle)
                                        .sheet(isPresented: $isPresentedMoreSheet) {
                                            InfoSheetViewComponent(detail: detail)
                                        }
                                    }
                                } else if !detail.comingSoon {
                                    VStack {
                                        Image(systemName: "network.slash")
                                            .font(.title)
                                        
                                        Text("Video is unavailible in this region")
                                            .font(.headline.bold())
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                    }
                                    .padding(15)
                                } else {
                                    VStack(alignment: .center) {
                                        Image(systemName: "gauge.with.needle")
                                            .font(.title)
                                        
                                        Text("key_comingsoon")
                                            .font(.headline.bold())
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                    }
                                    .padding(15)
                                }
                                
                                Text(detail.description)
                                    .padding(.top, 8)
                                    .lineLimit(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 28)
                        
                        Spacer()
                    }
                    .padding(.leading, 28)
                    
                    InfoTabViewIpad(detail: detail)
                        .padding(.vertical, 26)
                    
                    if let schedule = detail.schedule {
                        ForEach(schedule[0...0]) { schedule in
                            Label(schedule.name, systemImage: "chevron.right")
                                .hoverEffect(.highlight)
                                .labelStyle(TextFirstLabel())
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                                .onTapGesture {
                                    isPresentedScheduleSheet.toggle()
                                }
                            
                            ForEach(schedule.items.prefix(5)) { item in
                                SeasonRowView(title: item.title, russianEpisodeName: item.russianEpisodeName, releaseDate: item.releaseDate)
                            }
                        }
                        .sheet(isPresented: $isPresentedScheduleSheet) {
                            if let schedule = detail.schedule {
                                NavigationStack {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(alignment: .leading) {
                                            ForEach(schedule) { schedule in
                                                Text(schedule.name)
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .padding(.vertical, 10)
                                                
                                                ForEach(schedule.items) { item in
                                                    SeasonRowView(title: item.title, russianEpisodeName: item.russianEpisodeName, releaseDate: item.releaseDate)
                                                }
                                            }
                                        }
                                        .padding()
                                        .padding(.top, 30)
                                    }
                                    .toolbar {
                                        ToolbarItem(placement: .topBarTrailing) {
                                            Text("done").bold()
                                                .hoverEffect(.highlight)
                                                .foregroundStyle(.accent)
                                                .onTapGesture {
                                                    isPresentedScheduleSheet.toggle()
                                                }
                                        }
                                    }
                                    .ignoresSafeArea(.all)
                                    .navigationTitle("schedule")
                                    .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18, alignment: .leading)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 18)
                        .font(.system(size: 16, weight: .semibold))
                        .background {
                            Circle()
                                .frame(height: 30)
                                .foregroundStyle(.ultraThinMaterial)
                        }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ShareButton(color: .primary)
            }
        }
        .onAppear {
            Task {
                link = try await MovieDetailsParser.insertTrailerData(id: id)
            }
        }
    }
}

struct TextFirstLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}
