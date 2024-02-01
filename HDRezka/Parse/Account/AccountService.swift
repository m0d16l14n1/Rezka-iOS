//
//  AccountService.swift
//  HDRezka
//
//  Created by keet on 20.12.2023.
//

import Foundation

class AccountService: ObservableObject {
    func login(username: String, password: String) async throws -> Bool {
        var body = [String: String]()
        
        body["login_name"] = username
        body["login_password"] = password
        body["login_not_save"] = "0"
        
        let response = try await AccountNetwork().getCollections(body)
        
        let jsonObject = try JSONSerialization.jsonObject(with: Data(response.utf8), options: []) as! [String: Any]
        print(response)
        return jsonObject["success"] as! Bool
    }
}
