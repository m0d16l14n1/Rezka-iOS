//
//  SpeсialThanksView.swift
//  HDRezka
//
//  Created by keet on 03.11.2023.
//

import SwiftUI

struct AboutUsView: View {
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let buildVerison = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    
    var body: some View {
        VStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Label(
                            title: { Text("Thank you!") },
                            icon: { Image(systemName: "heart").foregroundStyle(.red) })
                        .font(.system(size: 34, weight: .bold))
                        .padding(.bottom)
                        
                        Text("thanks_special_info")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("key_information")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 22, weight: .bold))
                                .padding(.horizontal)
                        }
                        
                        PersonCardComponent(url: "https://rezka.otomir23.me/assets/keet.jpeg", job: "Code", name: "Keet", description: "Ведущий разработчик. Крутой.")
                        PersonCardComponent(url: "https://rezka.otomir23.me/assets/damir.jpeg", job: "Code", name: "otomir23", description: "Бэкенд донатов.")
                        PersonCardComponent(url: "https://rezka.otomir23.me/assets/owlu.jpeg", job: "UI/UX", name: "owlu", description: "Дизайн")
                        PersonCardComponent(url: "https://rezka.otomir23.me/assets/fonker.jpeg", job: "Code", name: "4nk1r", description: "Android dev.")
                    }
                    // TODO: Libraries
                    
                    Text(verbatim: "v\(appVersion?.description ?? "UNKNOWN"), build \(buildVerison?.description ?? "UNKNOWN")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    AboutUsView()
}
