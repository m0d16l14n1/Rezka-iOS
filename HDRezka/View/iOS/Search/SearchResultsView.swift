//
//  SearchResultsView.swift
//  HDRezka
//
//  Created by keet on 23.09.2023.
//

import SwiftUI
import Alamofire

struct SearchResultsView: View {
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    @EnvironmentObject var network: Network
    
    @State private var isShowingUnavailibleView = false
    
    @Binding var request: String
    
    var body: some View {
        NavigationStack {
            if !network.search.isEmpty {
                ScrollView(.vertical) {
                    VStack {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            SearchGridComponent()
                        } else {
                            SearchGridComponentIpad()
                        }
                    }
                }
                .navigationTitle (request)
            } else if isShowingUnavailibleView {
                ContentUnavailableView.search(text: request)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                isShowingUnavailibleView = true
            }
            
            AF.request("http://\(settingStore)/search/?do=search&subaction=search&q=\(request)", method: .get).responseString { response in
                Task {
                    if let htmlString = response.value {
                        try network.parseSearch(html: htmlString)
                    }
                }
            }
        }
    }
}
