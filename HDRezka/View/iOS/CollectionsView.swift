//
//  CollectionsView.swift
//  HDRezka
//
//  Created by keet on 23.11.2023.
//

import SwiftUI

struct CollectionsView: View {
    var body: some View {
        CollectionsListViewComponent()
            .environmentObject(CollectionsParser())
    }
}

#Preview {
    CollectionsView()
}
