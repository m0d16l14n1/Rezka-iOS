//
//  InfoTabView.swift
//  HDRezka
//
//  Created by keet on 15.10.2023.
//

import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

struct InfoTabView: View {
    
    var detail: MovieDetailed
    
    var body: some View {
        HStack() {
            
            if let imdbRating = detail.imdbRating {
                Group{
                    Spacer()
                    VStack(spacing: 4) {
                        Text("IMDb")
                            .font(.caption2)
                            .foregroundColor(.primary)
                        
                        Text(String(format: "%.1f", imdbRating.value))
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.medium)
                        StarsView(rating: CGFloat(imdbRating.value))
                    }
                }
            }
            
            if let kpRating = detail.kpRating {
                Spacer()
                
                Group{
                    VStack(spacing: 4) {
                        Text("КиноПоиск")
                            .font(.caption2)
                            .foregroundColor(.primary)
                        Text(String(format: "%.2f", kpRating.value))
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.medium)
                        StarsView(rating: CGFloat(kpRating.value))
                    }
                }
            }
            
            Spacer()
            
            Group {
                VStack(spacing: 4) {
                    Text("Duration")
                        .font(.caption2)
                        .foregroundColor(.primary)
                    Text(detail.duration)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.medium)
                    Text("Minutes")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Group {
                VStack(spacing: 4) {
                    Text("Age")
                        .font(.caption2)
                        .foregroundColor(.primary)
                    Text(detail.ageRestriction)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.medium)
                    Text("Years")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
        }
        .padding(.bottom, 8.0)
    }
}

struct StarsView: View {
    var rating: CGFloat
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 9))
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = (rating / CGFloat(5)) / 2 * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
                .mask(stars)
        )
        .foregroundColor(.gray)
    }
}
