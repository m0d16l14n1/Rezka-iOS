//
//  NewRowComponentIpad.swift
//  HDRezka
//
//  Created by keet on 06.12.2023.
//

import SwiftUI
import Alamofire

struct NewRowComponentIpad: View {
    @EnvironmentObject var network: Network
    
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    var body: some View {
        VStack {
            HStack {
                Text("key_new")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    
                } label: {
                    Text("key_more")
                }
            }
            .padding(.horizontal)
            .padding(.leading, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(network.movies[0...15]) { movie in
                        TitleCardRowComponentIpad(model: movie)
                            .padding(.leading)
                    }
                }
            }
        }
    }
}

#Preview {
    NewRowComponentIpad()
}
