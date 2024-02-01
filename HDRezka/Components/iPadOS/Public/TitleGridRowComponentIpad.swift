//
//  TitleCardRowComponentIpad.swift
//  HDRezka
//
//  Created by keet on 04.12.2023.
//

import SwiftUI
import Alamofire

struct TitleGridRowComponentIpad: View {
    @EnvironmentObject var network: Network
    
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    var body: some View {
        VStack {
            if !network.nowWatchingMovies.isEmpty {
                NavigationStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        //                        NewRowComponentIpad()
                        
                        VStack {
                            HStack {
                                Text("Now watching")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                NavigationLink {
                                    HomeGridViewIpad()
                                        .environmentObject(Network())
                                } label: {
                                    Text("key_more")
                                }
                                .hoverEffect(.highlight)
                            }
                            .padding(.horizontal)
                            .padding(.leading, 5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(network.nowWatchingMovies[0...15]) { movie in
                                        NavigationLink(destination: DetailsView(id: movie.id).environmentObject(MovieDetailsParser())) {
                                            TitleCardRowComponentIpad(model: movie)
                                                .padding(.leading)
                                                .hoverEffect(.lift)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Home")
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .onAppear {
            AF.request("http://\(settingStore)/?filter=watching", method: .get).responseString { response in
                Task {
                    if let htmlString = response.value {
                        try network.parseNowWatchingMovies(html: htmlString)
                    }
                }
            }
        }
        .onDisappear {
            network.nowWatchingMovies.removeAll()
        }
        .onChange(of: settingStore) {
            network.nowWatchingMovies.removeAll()
            
            AF.request("http://\(settingStore)/?filter=watching", method: .get).responseString { response in
                Task {
                    if let htmlString = response.value {
                        try network.parseNowWatchingMovies(html: htmlString)
                    }
                }
            }
        }
    }
}

#Preview {
    TitleGridRowComponentIpad()
        .environmentObject(Network())
}
