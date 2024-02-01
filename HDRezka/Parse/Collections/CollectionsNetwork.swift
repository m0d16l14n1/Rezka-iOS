//
//  CollectionsNetwork.swift
//  HDRezka
//
//  Created by keet on 21.11.2023.
//

import Foundation
import SwiftUI
import Alamofire

class CollectionsNetwork {
    
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    func getCollections(page: Int) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "http://\(settingStore)/collections/page/\(page)"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .get, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMoviesInCollection(id: String, page: Int) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "http://\(settingStore)/collections/\(id)/page/\(page)"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .get, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getMoviesInCollectionFiltered(id: String, page: Int, filter: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "http://\(settingStore)/collections/\(id)/page/\(page)/?filter=\(filter)"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .get, headers: headers).responseString { response in
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
