//
//  CollectionsViewIpad.swift
//  HDRezka
//
//  Created by keet on 06.12.2023.
//

import SwiftUI

struct CollectionsViewIpad: View {
    var body: some View {
        CollectionsListViewComponentIpad()
            .environmentObject(CollectionsParser())
    }
}

#Preview {
    CollectionsViewIpad()
}
