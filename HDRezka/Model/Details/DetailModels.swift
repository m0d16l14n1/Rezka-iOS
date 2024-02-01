//
//  DetailModels.swift
//  HDRezka
//
//  Created by keet on 24.09.2023.
//

import Foundation

struct MovieRating {
    let value: Float
    let votesCount: String
}

struct MovieGenre: Identifiable { // is this even used?
    let id: String
    let name: String
}

struct MovieList: Identifiable { // is this even used?
    let id: String
    let name: String
    let moviePosition: Int
}

struct SeriesScheduleGroup: Identifiable { // is this even used?
    var id = UUID()
    let name: String
    let items: Array<SeriesScheduleItem>
}

struct SeriesScheduleItem: Identifiable { // is this even used?
    var id = UUID()
    let title: String
    let russianEpisodeName: String
    let originalEpisodeName: String? // null for russian series
    let releaseDate: String
}

struct MovieFranchisePart: Identifiable { // is this even used?
    let id: String
    let name: String
    let year: String
    let rating: Float?
    let current: Bool
    let position: Int
}

struct PersonSimple: Identifiable { // is this even used?
    let id: String
    let name: String
}

struct MovieVoiceActing: Hashable {
    let id: String
    let name: String
    let translatorId: String
    let isCamrip: String
    let isAds: String
    let isDirector: String
    let isSelected: Bool
}

struct MovieVoiceActingRating {
    let name: String
    let percent: Float
}

struct MovieEpisode: Hashable {
    let id: String
    let name: String
    let isSelected: Bool
}

struct Bookmark: Hashable {
    let id: Int
    let name: String
}

struct MovieSeason: Hashable {
    let id: String
    let name: String
    let episodes: Array<MovieEpisode>
    let isSelected: Bool
    
//    func toShortString() -> String {
//        return "MovieSeason(id=\(id), name=\(name), episodes=\(episodes.count), isSelected=\(isSelected))"
//    }
}

///  series update models
/*
struct SeriesUpdateTitle {
    let day: String
    let date: String
}

struct SeriesUpdate {
    let name: String
    let season: String
    let episode: String
    let dub: String
}
*/

struct MovieVideo: Hashable {
    let name: String
    let _360p: String?
    let _480p: String?
    let _720p: String?
    let _1080p: String?
    let _1080pUltra: String?
    let _1440p: String?
    let _2160p: String?
    let position: Int
    
    func getMaxQuality() -> String {
        return _2160p ?? _1440p ?? _1080pUltra ?? _1080p ?? _720p ?? _480p ?? _360p!
    }
    
    func getClosestTo(quality: String) -> String {
        return switch (quality) {
        case "2160p", "2160p (4K)":
            _2160p ?? _1440p ?? _1080pUltra ?? _1080p ?? _720p ?? _480p
            ?? _360p!
            
        case "1440p", "1440p (2K)":
            _1440p ?? _1080pUltra ?? _1080p ?? _720p ?? _480p ?? _360p!
        case "1080p Ultra":
            _1080pUltra ?? _1080p ?? _720p ?? _480p ?? _360p!
        case "1080p":
            _1080p ?? _720p ?? _480p ?? _360p!
        case "720p":
            _720p ?? _480p ?? _360p!
        case "480p":
            _480p ?? _360p!
        case "360p":
            _360p!
        default:
            fatalError("Unknown quality: \(quality)")
        }
    }
    
    func getAvailableQualities() -> [String: String] {
        var result = [String: String]()
        
        if let _360p = _360p {
            result["360p"] = _360p
        }
        if let _480p = _480p {
            result["480p"] = _480p
        }
        if let _720p = _720p {
            result["720p"] = _720p
        }
        if let _1080p = _1080p {
            result["1080p"] = _1080p
        }
        if let _1080pUltra = _1080pUltra {
            result["1080p Ultra"] = _1080pUltra
        }
        if let _1440p = _1440p {
            result["1440p (2K)"] = _1440p
        }
        if let _2160p = _2160p {
            result["2160p (4K)"] = _2160p
        }
        
        return result
    }
    
    func getFileName(quality: String) -> String {
        let link = getClosestTo(quality: quality)
        return link.components(separatedBy: "/").last!
            .components(separatedBy: ".").first!
    }
    
    func defineQuality(link: String) -> String {
        return switch (link) {
        case _2160p:
            "2160p"
        case _1440p:
            "1440p"
        case _1080pUltra:
            "1080p Ultra"
        case _1080p:
            "1080p"
        case _720p:
            "720p"
        case _480p:
            "480p"
        case _360p:
            "360p"
        default:
            fatalError("Undefined link: \(link)")
        }
    }
}
