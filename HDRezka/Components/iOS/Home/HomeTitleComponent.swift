//
//  HomeTitleComponent.swift
//  HDRezka
//
//  Created by keet on 13.09.2023.
//

import SwiftUI

struct HomeProfile: View {
    var body: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.red)
            .frame (width: 36, height: 36)
            .padding(.trailing)
            .padding(.top)
    }
}
