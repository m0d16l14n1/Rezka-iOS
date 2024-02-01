//
//  InfoTabViewIpad.swift
//  HDRezka
//
//  Created by keet on 09.12.2023.
//

import SwiftUI

struct InfoTabViewIpad: View {
    
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
                
                Spacer()
                Divider()
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
                Spacer()
                Divider()
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
            Divider()
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
