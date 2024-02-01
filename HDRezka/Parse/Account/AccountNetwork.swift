//
//  AccountNetwork.swift
//  HDRezka
//
//  Created by keet on 20.12.2023.
//

import Foundation
import SwiftUI
import Alamofire

class AccountNetwork {
    
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror

    func getCollections(_ body: [String: String]) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "http://\(settingStore)/ajax/login/"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .get, parameters: body, headers: headers).responseString { response in
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
