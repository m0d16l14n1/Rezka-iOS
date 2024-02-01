//
//  ContentViewIpad.swift
//  HDRezka
//
//  Created by keet on 03.12.2023.
//

import SwiftUI

struct ContentViewIpad: View {
    @State private var isPresented = false
    
    var body: some View {
        NavigationSplitView {
            HStack {
                VStack {
                    List {
                        NavigationLink {
                            HomeViewIpad()
                                .environmentObject(Network())
                        } label: {
                            Label("Home", systemImage: "house")
                        }
                        .hoverEffect(.highlight)
                        
                        NavigationLink {
                            CollectionsViewIpad()
                        } label: {
                            Label("key_collections", systemImage: "square.grid.2x2.fill")
                        }
                        .hoverEffect(.highlight)
                        
                        NavigationLink {
                            SearchView()
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .hoverEffect(.highlight)
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .hoverEffect(.highlight)
                                    .font(.title.weight(.semibold))
                                    .foregroundColor(.accentColor)
                                Text("key_profile")
                                    .hoverEffect(.highlight)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .bold()
                                
                                Spacer()
                            }
                            .onTapGesture {
                                isPresented.toggle()
                            }
                            .sheet(isPresented: $isPresented) {
                                ProfileView()
                                    .presentationDragIndicator(.visible)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text(verbatim: "HDRezka"))
            
        } detail: {
            HomeViewIpad()
        }
        .navigationSplitViewStyle(.automatic)
    }
}

#Preview {
    ContentViewIpad()
        .environmentObject(Network())
}
