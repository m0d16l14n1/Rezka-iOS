//
//  AutoMirrorService.swift
//  HDRezka
//
//  Created by keet on 18.11.2023.
//

import Foundation
import Alamofire

class AutoMirrorService {
    static func updateMirror() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "https://raw.githubusercontent.com/MrIkso/hdrezka-fetcher/main/mirror.txt"
            
            AF.request(url, method: .get).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
