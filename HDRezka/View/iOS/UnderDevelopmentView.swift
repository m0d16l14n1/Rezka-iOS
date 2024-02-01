//
//  MediaLibraryView.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI

struct UnderDevelopmentView: View {
    var body: some View {
        VStack {
            VStack {
                VStack {
                    HStack {
                        Image("logo_svg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        
                        Text(verbatim: "HDRezka")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                }
                .padding()
                
                Spacer()
            }
            
            VStack {
                VStack {
                    Text(verbatim: "138 5 15 \n12 8 0 4 \n17 19 20")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text(verbatim: "1")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.secondary)
                        
                        Text(verbatim: "404")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.accent)
                    }
                }
                .frame(width: 190, height: 220)
                
                Spacer()
            }
            .padding(.bottom, 200)
            
            HStack {
                Text("pageisunderdevelop")
                    .font(.system(size: 18, weight: .light, design: .rounded))
            }
            .padding()
        }
    }
}

#Preview {
    UnderDevelopmentView()
}
