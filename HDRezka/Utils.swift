//
//  Utils.swift
//  HDRezka
//
//  Created by keet on 02.10.2023.
//

import Foundation
import SwiftUI

extension String {
    func toShortNumber() -> String {
        let numbers = Int(replacingOccurrences(of: "[\\D\\s]", with: "", options: .regularExpression)) ?? 0
        
        switch numbers {
        case 10_000_000...100_000_000:
            return "\(numbers / 1_000_000)M"
        case 1_000_000...10_000_000:
            return "\(numbers / 1_000_000),\(String(numbers % 1_000_000).first!)M"
        case 10_000...1_000_000:
            return "\(numbers / 1_000)K"
        case 1_000...10_000:
            return "\(numbers / 1_000),\(String(numbers % 1_000).first!)K"
        default:
            return String(numbers)
        }
    }
    
    func checkIfLinkIsBroken(_ link: String) -> Bool { // unused
        let pattern = "((http://)|(https://))[a-zA-Z\\d/:.=]+(\\.mp4)"
        
        let isMatch = link.range(of: pattern, options: .regularExpression) != nil
        
        if isMatch {
            return true
        } else {
            return false
        }
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
