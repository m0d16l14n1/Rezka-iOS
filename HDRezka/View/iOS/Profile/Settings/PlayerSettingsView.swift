//
//  PlayerSettingsView.swift
//  HDRezka
//
//  Created by keet on 17.01.2024.
//

import SwiftUI

struct PlayerSettingsView: View {
    @AppStorage("hideNotch") var isHidingNotch = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Toggle(isOn: $isHidingNotch) {
                            Text("key_toggle+safe+areas")
                        }
                        
                        HStack {
                            Spacer()
                            HideNotchAnimatedViewComponent(isAnimated: $isHidingNotch)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("key_player")
        }
    }
}

#Preview {
    PlayerSettingsView()
}
