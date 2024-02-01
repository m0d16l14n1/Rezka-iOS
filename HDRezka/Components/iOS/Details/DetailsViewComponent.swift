//
//  DetailsView.swift
//  HDRezka
//
//  Created by keet on 03.10.2023.
//

import SwiftUI
import FancyScrollView

struct DetailsViewComponent: View {
    
    var id: String
    var detail: MovieDetailed
        
    @State private var isPresentedScheduleSheet = false
    @State private var isPresentedPlaySheet = false
    @State private var isPresentedDownloadSheet = false
    @State private var isPresentedMoreSheet = false
    @State private var isPresentedPlayer = false
    @State private var video = ""
    
    @State private var link: String? = ""
    
    var body: some View {
        NavigationStack {
            FancyScrollView(title: detail.nameRussian,
                            headerHeight: 650,
                            scrollUpHeaderBehavior: .parallax,
                            scrollDownHeaderBehavior: .offset,
                            header: {
                GradientImageView(url: detail.poster, height: 650, blurStyle: .dark)
                    .overlay(content: {
                        ZStack(alignment: .bottom) {
                            VStack(alignment: .center, spacing: 0) {
                                Spacer()
                                
                                Text(detail.nameRussian)
                                    .font(Font.system(.largeTitle)
                                        .leading(.tight))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                    .frame(width: UIScreen.main.bounds.width / 1.2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .lineLimit(4)
                                
                                ForEach(detail.genres[0...0]) { genres in
                                    Text("\(genres.name) • \(detail.releaseDate ?? "unknown") • \(detail.country)".uppercased())
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(.bottom)
                                        .frame(width: UIScreen.main.bounds.width/1.2)
                                }
                                
                                if detail.availability == Availability.AVAILABLE_ON_REZKA && !detail.comingSoon {
                                    Button {
                                        isPresentedPlaySheet.toggle()
                                    } label: {
                                        Label("Watch", systemImage: "play.fill")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: UIScreen.main.bounds.width/1.2, maxHeight: 20)
                                    }
                                    .padding(.bottom)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.white)
                                    .buttonBorderShape(.roundedRectangle(radius: 12))
                                    .controlSize(.large)
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
                                        Label("Download", systemImage: "icloud.and.arrow.down")
                                            .font(.system(size: 17, weight: .medium))
                                            .frame(maxWidth: UIScreen.main.bounds.width/1.2, maxHeight: 20 )
                                    }
                                    .padding(.bottom)
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(UIColor.opaqueSeparator).opacity(0.4))
                                    .buttonBorderShape(.roundedRectangle(radius: 12))
                                    .controlSize(.large)
                                    .sheet(isPresented: $isPresentedDownloadSheet) {
                                        DownloadParamsSheet(id: id, voiceActing: detail.voiceActing, seasons: detail.seasons, downloadManager: DownloadViewModel())
                                            .environmentObject(MovieDetailsService())
                                            .environmentObject(DownloadViewModel())
                                            .presentationDragIndicator(.visible)
                                            .presentationDetents([.medium, .large])
                                    }
                                } else if !detail.comingSoon {
                                    VStack {
                                        Image(systemName: "network.slash")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                        
                                        Text("Video is unavailible in this region")
                                            .font(.headline.bold())
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                    }
                                    .padding(15)
                                } else {
                                    VStack(alignment: .center) {
                                        Image(systemName: "gauge.with.needle")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                        
                                        Text("key_comingsoon")
                                            .font(.headline.bold())
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.center)
                                            .padding(5)
                                    }
                                    .padding(15)
                                }
                            }
                        }
                    })
            }) {
                VStack(alignment: .leading) {
                    InfoTabView(detail: detail)
                        .padding(.top)
                    ZStack {
                        Text(detail.description)
                            .font(.body)
                            .lineLimit(3)
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                ZStack(alignment: .trailing){
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(height: 20)
                                        .background {
                                            LinearGradient(gradient: Gradient(stops: [
                                                Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.2),
                                                Gradient.Stop(color: .clear, location: 0.6)]),
                                                           startPoint: .trailing, endPoint: .leading)
                                            
                                        }
                                    Spacer()
                                    Button("key_more") {
                                        isPresentedMoreSheet.toggle()
                                    }
                                    .padding(.trailing)
                                }
                                .sheet(isPresented: $isPresentedMoreSheet) {
                                    InfoSheetViewComponent(detail: detail, trailerLink: link)
                                }
                            }
                        }
                    }
                    
                    if let schedule = detail.schedule {
                        ForEach(schedule[0...0]) { schedule in
                            Label(schedule.name, systemImage: "chevron.right")
                                .labelStyle(TextFirstLabel())
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    isPresentedScheduleSheet.toggle()
                                }
                            
                            ForEach(schedule.items.prefix(5)) { item in
                                SeasonRowView(title: item.title, russianEpisodeName: item.russianEpisodeName, releaseDate: item.releaseDate)
                            }
                        }
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
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                link = try await MovieDetailsParser.insertTrailerData(id: id)
            }
        }
    }
}

/* TODO: preview
#Preview {
    DetailsViewComponent(id: "", russianTitle: "Барби", poster: "https://www.instyle.com/thmb/vZCEkHB1nBMIes2tcKTUAMP0zf0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/BarbiePosterEmbed-de7c886812184414977730e920d77a65.jpg", genre: [MovieGenre(id: "", name: "Фэнтези")], releaseDate: "22 июня 2023 года", country: "США", description: "В центре сюжета находится мрачная и немногословная Уэнсдэй — старшая дочь эксцентричной семейки Аддамс, которая из-за детей упала и сдохла блин", imdbRating: MovieRating(value: 7.2, votesCount: "100000"), kpRating: MovieRating(value: 8.0, votesCount: "100000"), schedule: [SeriesScheduleGroup(name: "name", items: [SeriesScheduleItem(title: "title", russianEpisodeName: "russian episode name", originalEpisodeName: "original episode name", releaseDate: "1.1.2023")])], duration: "120", age: "12+", voiceActing: [MovieVoiceActing(id: "", name: "", translatorId: "", isCamrip: "", isAds: "", isDirector: "", isSelected: true)], isAvailible: Availability.AVAILABLE_ON_REZKA)
        .environmentObject(MovieDetailsParser())
}
*/
