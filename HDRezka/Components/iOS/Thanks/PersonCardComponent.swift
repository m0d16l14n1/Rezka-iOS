//
//  PersonCardComponent.swift
//  HDRezka
//
//  Created by keet on 04.11.2023.
//

import SwiftUI

struct PersonCardComponent: View {
    var url: String
    var job: String
    var name: String
    var description: String
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                    .cornerRadius(50)
                    .padding(.all, 20)
            } placeholder: {
                Color.clear
                    .frame(width: 110, height: 110)
            }
            
            VStack(alignment: .leading) {
                Text(job)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.6))
                Text(name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text(description)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.secondary)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    PersonCardComponent(url: "https://rezka.otomir23.me/assets/keet.jpeg", job: "Code", name: "4nk1r", description: "tysm!")
}
