//
//  SeasonListView.swift
//  HDRezka
//
//  Created by keet on 15.10.2023.
//

import SwiftUI

struct SeasonRowView: View {
    let title: String
    let russianEpisodeName: String
    let releaseDate: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    Text(russianEpisodeName)
                        .font(.callout)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                Spacer()
                Text(releaseDate)
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
            }
            .padding(.bottom, 8.0)
        }
    }
}
