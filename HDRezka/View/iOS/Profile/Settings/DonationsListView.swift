//
//  DonationsListView.swift
//  HDRezka
//
//  Created by keet on 05.11.2023.
//

import SwiftUI

struct DonationsListView: View {
    @EnvironmentObject var donationManager: DonationManager
    
    @Environment(\.openURL) var openURL
    
    let column = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                Image(systemName: "gift")
                    .foregroundStyle(.red)
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom)
                
                Text("key_donation_info")
                    .font(.callout)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text(verbatim: "русский текст будет исправлен в скором времени (надеюсь)")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Button {
                    openURL(URL(string: "https://donatty.com/keet")!)
                } label: {
                    Text("Поддержать")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
                .padding(.horizontal, 16)
            
            LazyVGrid(columns: column) {
                if !donationManager.donationsList.isEmpty {
                    ForEach(donationManager.donationsList) { donation in
                        if donation.value >= 349 {
                            DonationGradientCard(name: donation.name, value: donation.value, message: donation.message)
                        } else {
                            DonationCard(name: donation.name, value: donation.value, message: donation.message)
                        }
                    }
                } else {
                    VStack {
                        ProgressView()
                            .padding(.top, 30)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await donationManager.getDonations()
            }
        }
    }
}

#Preview {
    DonationsListView()
        .environmentObject(DonationManager())
}
