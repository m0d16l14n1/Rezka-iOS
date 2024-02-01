//
//  HomeViewIpad.swift
//  HDRezka
//
//  Created by keet on 29.11.2023.
//

import SwiftUI
import Alamofire

struct HomeGridViewIpad: View {
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    @EnvironmentObject var network: Network
    
    @State private var page = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                TitleGridComponentIpad(page: $page)
                    .onLoad {
                        page = 1
                    }
            }
            .navigationTitle("Now watching")
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
}

#Preview {
    HomeGridViewIpad()
        .environmentObject(Network())
}
