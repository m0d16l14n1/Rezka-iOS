//
//  DonationRequest.swift
//  HDRezka
//
//  Created by keet on 05.11.2023.
//

import Foundation
import Alamofire

class DonationManager: ObservableObject {
    
    @Published var donationsList = [DonationModel]()
    
    @MainActor func getDonations() async throws -> [DonationModel] {
        let json = try await self.getDonationsList()
        
        let data = json.data(using: .utf8)!
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        let jsonDict = jsonObject as? [String: Any]
        let dataDict = jsonDict!["data"] as? [String: Any]
        let itemsArray = dataDict!["items"] as! [[String: Any]]
        
        for item in itemsArray {
            if let id = item["id"] as? String,
               let name = item["name"] as? String,
               let amount = item["amount"] as? Int {
                let message = item["message"] as? String ?? ""
                
                let donationModel = DonationModel(id: id, name: name, message: message, value: amount)
                donationsList.append(donationModel)
            }
        }
        
        return donationsList
    }
    
    func getDonationsList() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("http://rezka.otomir23.me/donations", method: .get).responseString { response in
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
