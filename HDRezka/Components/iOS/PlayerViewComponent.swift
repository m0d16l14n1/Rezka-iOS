//
//  PlayerViewComponent.swift
//  HDRezka
//
//  Created by keet on 25.11.2023.
//

import SwiftUI
import AVKit

struct PlayerViewComponent: View {
    var url: String
    
    @AppStorage("hideNotch") var isHidingNotch = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if !isHidingNotch {
            VideoPlayer(player: AVPlayer(url: URL(string: url)!)) {
                ViewThatFits {
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(20)
                .padding(.top)
                .ignoresSafeArea()
            }
            .onAppear {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea()
            .persistentSystemOverlays(.hidden)
        } else {
            VideoPlayer(player: AVPlayer(url: URL(string: url)!)) {
                ViewThatFits {
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(20)
                .padding(.top)
                .ignoresSafeArea()
            }
            .onAppear {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error)
                }
            }
            .background(.black)
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .persistentSystemOverlays(.hidden)
            .ignoresSafeArea(edges: [.vertical, .trailing])
        }
    }
}

#Preview {
    PlayerViewComponent(url: "https://i.otomir23.me/die.mp4")
}
