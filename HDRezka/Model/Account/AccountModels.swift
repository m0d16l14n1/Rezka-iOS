//
//  AccountModels.swift
//  HDRezka
//
//  Created by keet on 16.12.2023.
//

import Foundation

struct MovieWatchLater {
    var id: String
    var name: String
    var details: String
    var watchingInfo: String
    var date: String
    var buttonText: String?
    var dataId: String
}

struct SeriesUpdateGroup {
    var date: String
    var releasedEpisodes: [SeriesUpdateItem]
}

struct SeriesUpdateItem {
    var id: String
    var seriesName: String
    var season: String
    var releasedEpisode: String
    var chosenVoiceActing: String
}
