//
//  MovieDetailsService.swift
//  HDRezka
//
//  Created by keet on 22.10.2023.
//

import Foundation
import SwiftUI
import Alamofire

class MovieDetailsService: ObservableObject {
    
    @AppStorage("mirror") var settingStore = DefaultSettings.mirror
    
    func getMovieVideo(voiceActing: MovieVoiceActing, season: MovieSeason?, episode: MovieEpisode?, id: String) async throws -> MovieVideo { // remove id
        var builder = [String: String]()
        
        if !voiceActing.id.isEmpty {
            builder["id"] = voiceActing.id.components(separatedBy: "/").last?.components(separatedBy: "-").first
        } else {
            builder["id"] = id.components(separatedBy: "/").last?.components(separatedBy: "-").first
        }
        
        builder["translator_id"] = voiceActing.translatorId
        
        if !voiceActing.isCamrip.isEmpty {
            builder["is_camrip"] = voiceActing.isCamrip
        }
        
        if !voiceActing.isAds.isEmpty {
            builder["is_ads"] = voiceActing.isAds
        }
        
        if !voiceActing.isDirector.isEmpty {
            builder["is_director"] = voiceActing.isDirector
        }
        
        if let season = season, let episode = episode {
            builder["season"] = season.id
            builder["episode"] = episode.id
            builder["action"] = "get_stream"
        } else {
            builder["action"] = "get_movie"
        }
        
        let response = try await self.getMovieVideo(params: builder)
        let video = try self.parseMovieVideo(response: response)
        
        
        return video
    }
    
    func getMovieVideo(params: [String: String]) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let time = String(format: "%.0f", Date().timeIntervalSince1970)
            let url: URLConvertible = "http://\(settingStore)/ajax/get_cdn_series/?t=\(time)"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .post, parameters: params, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getSeriesSeasons(movieId: String, voiceActing: MovieVoiceActing) async throws -> [MovieSeason]? {
        var params = [String: String]()
        
        let id = movieId.components(separatedBy: "/").last?.components(separatedBy: "-").first
        
        params["id"] = id
        params["translator_id"] = voiceActing.translatorId
        params["action"] = "get_episodes"
        
        let response = try await self.getMovieVideo(params: params)
        
        return MovieDetailsParser().parseSeriesSeasons(response)
    }
    
    func getMovieTrailer(_ id: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let url: URLConvertible = "http://\(settingStore)/engine/ajax/gettrailervideo.php"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            
            AF.request(url, method: .post, parameters: ["id" : id], headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func parseMovieVideo(response: String) throws -> MovieVideo {
        return response.getMovieVideo()
    }
}
