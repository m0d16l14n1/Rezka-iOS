//
//  SettingView.swift
//  HDRezka
//
//  Created by keet on 30.09.2023.
//

import SwiftUI
import Alamofire

struct SettingView: View {
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    @EnvironmentObject var network: Network
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    @State private var animateIcon = false
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField(settingStore, text: $text)
                            .textFieldStyle(.plain)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        Button {
                            withAnimation(.default) {
                                animateIcon.toggle()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    animateIcon.toggle()
                                }
                            }
                            
                            Task {
                                text = try await AutoMirrorService.updateMirror()
                                    .replacingOccurrences(of: "https://", with: "")
                                    .replacingOccurrences(of: "http://", with: "")
                            }
                        } label: {
                            Label("key_reloadmirror", systemImage: animateIcon ? "checkmark" : "arrow.circlepath")
                                .contentTransition(.symbolEffect(.replace))
                        }
                    } header: {
                        Label("mirror", systemImage: "network")
                    }
                    
                    VStack {
                        Text("settings_mirror_desc")
                            .foregroundStyle(.primary)
                            .font(.subheadline) +
                        Text(verbatim: " mirror@hdrezka.org")
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                    }
                    
                    Section {
                        NavigationLink {
                            
                            PlayerSettingsView()
                        } label: {
                            Label("key_player+settings", systemImage: "rectangle.inset.filled.and.person.filled")
                        }
                        
                        NavigationLink {
                            AboutUsView()
                        } label: {
                            Label("about_app_settings", systemImage: "heart")
                        }
                        
                        Button {
                            openURL(URL(string: "https://t.me/hdnightly")!)
                        } label: {
                            Label("key_telegram+channel", systemImage: "paperplane")
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if text != "" {
                            settingStore = self.validateMirror(mirror: text)
                        }
                        
                        network.movies.removeAll()
                        network.nowWatchingMovies.removeAll()
                        
                        AF.request("http://\(settingStore)/?filter=watching", method: .get).responseString { response in
                            Task {
                                if let htmlString = response.value {
                                    if UIDevice.current.userInterfaceIdiom == .phone {
                                        try network.parse(html: htmlString)
                                    } else {
                                        try network.parse(html: htmlString)
                                        try network.parseNowWatchingMovies(html: htmlString)
                                    }
                                }
                            }
                        }
                        
                        dismiss()
                    } label: {
                        Text("Save")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
    
    fileprivate func validateMirror(mirror: String) -> String {
        if mirror.range(of: #"^(http://|https://)(\w+|[-_.])+.\w+/$"#, options: .regularExpression) != nil {
            return mirror
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .replacingOccurrences(of: "/", with: "")
        } else if mirror.range(of: #"^(http://|https://)(\w+|[-_.])+.\w+$"#, options: .regularExpression) != nil {
            return mirror
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
        } else if mirror.range(of: #"^(\w+|[-_.])+.\w+$"#, options: .regularExpression) != nil {
            return mirror
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
        } else if mirror.range(of: #"^(\w+|[-_.])+.\w+/$"#, options: .regularExpression) != nil {
            return mirror
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .replacingOccurrences(of: "/", with: "")
        } else {
            return mirror
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(Network())
}
