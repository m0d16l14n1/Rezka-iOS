//
//  DonationCard.swift
//  HDRezka
//
//  Created by keet on 05.11.2023.
//

import SwiftUI

struct DonationCard: View {
    var name: String
    var value: Int
    var message: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    if !message.isEmpty {
                        Text(message)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("donationcard_emptymessage")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding()
                
                Spacer()
                
                Text("\(value)₽")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding()
                
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
        }
    }
}

#Preview {
    DonationCard(name: "4nk1r", value: 1000, message: "tysm!")
}
