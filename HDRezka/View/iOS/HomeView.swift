//
//  MainView.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI
import Alamofire

struct HomeView: View {
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    @EnvironmentObject var network: Network
    
    @State private var page = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    TitleGridComponent(page: $page)
                }
                .navigationTitle("Now watching")
            }
        }
        .preferredColorScheme(.none)
        .onLoad {
            page = 1
        }
        .onChange(of: page) {
            AF.request("http://\(settingStore)/page/\(page)/?filter=watching", method: .get).responseString { response in
                Task {
                    if let htmlString = response.value {
                        try network.parse(html: htmlString)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Network())
}
