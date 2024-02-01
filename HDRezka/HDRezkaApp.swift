//
//  HDRezkaApp.swift
//  HDRezka
//
//  Created by keet on 12.09.2023.
//

import SwiftUI

@main
struct HDRezkaApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
