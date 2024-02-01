//
//  SearchView.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI
import Alamofire

struct SearchView: View {
    @EnvironmentObject var network: Network
    
    @State private var search = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("")
                    .searchable(text: $search)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onChange(of: search) { value in
                        AF.request("https://hdrezkabmmshq.org/engine/ajax/search.php/?q=\(search)", method: .get).responseString { response in
                            Task {
                                network.search.removeAll()
                                if let htmlString = response.value {
                                    try await network.parseQuickSearch(html: htmlString)
                                }
                            }
                        }
                    }
            }
            
            ScrollView(.vertical) {
                ForEach(network.search) { result in
                    HStack {
                        NavigationLink(destination: EmptyView()) {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .foregroundStyle(.primary)
                            
                            HStack {
                                Text(result.name)
                                    .foregroundStyle(.primary)
                                
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
                .animation(.smooth)
            }
            .navigationTitle("Search")
            .navigationBarLargeTitleItems (trailing: HomeProfileComponent())
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(Network())
}
