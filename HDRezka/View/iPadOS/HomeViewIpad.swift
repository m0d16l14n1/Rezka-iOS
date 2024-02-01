//
//  HomeViewIpad.swift
//  HDRezka
//
//  Created by keet on 04.12.2023.
//

import SwiftUI
import Alamofire

struct HomeViewIpad: View {    
    @EnvironmentObject var network: Network
    
    var body: some View {
        VStack {
            TitleGridRowComponentIpad()
        }
    }
}

#Preview {
    HomeViewIpad()
        .environmentObject(Network())
}
