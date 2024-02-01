//
//  SearchView.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI
import Alamofire

struct SearchView: View {
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    @EnvironmentObject var network: Network
    
    @State private var search = ""
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Color.clear
                    .foregroundStyle(.clear)
                    .frame(width: 0, height: 0)
                    .searchable(text: $search)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: search) { value in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // FIXME: useless requests for fast type
                            AF.request("http://\(settingStore)/engine/ajax/search.php/?q=\(search)", method: .get).responseString { response in
                                Task {
                                    network.quickSearch.removeAll()
                                    if let htmlString = response.value {
                                        try network.parseQuickSearch(html: htmlString)
                                    }
                                }
                            }
                        }
                    }
                    .submitLabel(.search)
                    .onSubmit(of: .search) {
                        network.search.removeAll()
                        isPresented.toggle()
                    }
                    .navigationDestination(isPresented: $isPresented) {
                        SearchResultsView(request: $search)
                    }
            }
            
            ScrollView(.vertical) {
                ForEach(network.quickSearch) { result in
                    HStack {
                        NavigationLink(destination: DetailsView(id: result.id).environmentObject(MovieDetailsParser())) {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .foregroundStyle(.primary)
                            
                            VStack(alignment: .leading) {
                                Text(result.name)
                                    .padding(.leading, 5)
                                    .foregroundStyle(.primary)
                                    .lineLimit(2)
                                
                                Text(result.details)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(3)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .animation(.smooth) // FIXME: fix animation
            }
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(Network())
}
