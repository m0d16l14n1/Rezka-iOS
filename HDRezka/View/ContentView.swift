//
//  ContentView.swift
//  HDRezka
//
//  Created by keet on 12.09.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                CollectionsView()
                    .tabItem {
                        Label("key_collections", systemImage: "square.grid.2x2.fill")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                ProfileView()
                    .tabItem {
                        Label("key_profile", systemImage: "person.circle.fill")
                    }
                    .environmentObject(AccountService())
            }
        } else {
            ContentViewIpad()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Network())
        .environment(\.locale, Locale.init(identifier: "en"))
}

#Preview {
    ContentView()
        .environmentObject(Network())
        .environment(\.locale, Locale.init(identifier: "ru"))
}
