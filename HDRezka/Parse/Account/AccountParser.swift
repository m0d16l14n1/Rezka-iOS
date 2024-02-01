//
//  AccountParser.swift
//  HDRezka
//
//  Created by keet on 16.12.2023.
//

import Foundation
import SwiftSoup

class AccountParser: ObservableObject {
    
    @Published var watchingLaterMovies = [MovieWatchLater]()
    @Published var seriesUpdates = [SeriesUpdateGroup]()
    
    func parseWatchingLaterMovies(html: String) throws -> [MovieWatchLater] {
        try SwiftSoup.parse(html)
            .getWatchingLaterMovies().forEach { movie in
                let id = try movie.getId()
                let name = try movie.getName()
                let details = try movie.getDetails()
                let watchingInfo = try movie.getWatchingInfo()
                let date = try movie.getDate()
                let buttonText = try movie.getButtonText()
                let dataId = try movie.getDataId()
                
                watchingLaterMovies.append(
                    MovieWatchLater(id: id, name: name, details: details, watchingInfo: watchingInfo, date: date, buttonText: buttonText, dataId: dataId)
                )
            }
        
        return watchingLaterMovies
    }
    
    func parseSeriesUpdates(html: String) throws -> [SeriesUpdateGroup] {
        try SwiftSoup.parse(html)
            .getSeriesUpdateGroups().forEach { group in
                let date = try group
                    .select("div.b-seriesupdate__block_date")
                    .text()
                    .replacingOccurrences(of: "развернуть", with: "")
                var trackedItems = [SeriesUpdateItem]()
                
                try group
                    .getTrackedItems()
                    .forEach { item in
                        let id = try item.getSeriesUpdateId()
                        let name = try item.getSeriesUpdateName()
                        let season = try item.getSeriesUpdateSeason()
                        let releasedEpisode = try item.getSeriesUpdateReleasedEpisode()
                        let voiceActing = try item.getSeriesUpdateVoiceActing()

                        trackedItems.append(
                            SeriesUpdateItem(
                                id: id,
                                seriesName: name,
                                season: season,
                                releasedEpisode: releasedEpisode,
                                chosenVoiceActing: voiceActing
                            )
                        )
                    }
                
                if !trackedItems.isEmpty {
                    seriesUpdates.append(SeriesUpdateGroup(date: date, releasedEpisodes: trackedItems))
                }
            }
        
        return seriesUpdates
    }
    
    func checkRegistration(html: String) throws -> Bool {
        let scriptValue = try SwiftSoup.parse(html).select("script").first()?.html()
        
        return (scriptValue?.contains("location") == true || scriptValue?.isEmpty == true)
    }
    
    func checkRegistrationData(html: String) throws -> Bool {
        return try !SwiftSoup.parse(html).select("span.string-ok").isEmpty()
    }
    
    func parseBookmarks(html: String) throws -> [Bookmark] {
        try SwiftSoup.parse(html)
            .select("div.b-favorites_content__cats_list_item")
            .map { category in
                let lastIndex = category.id().lastIndex(of: "-")
                return Bookmark(
                    id: Int(category.id().suffix(from: category.id().index(after: lastIndex!)))!,
                    name: try category.select("span.name").text()
                )
            }
    }
}

extension Document {
    fileprivate func getWatchingLaterMovies() throws -> [Element] {
        var data = try self.select("div.b-videosaves__list_item")
        
        if !data.isEmpty() {
            var newData = data.array()
            newData.removeFirst()
            return newData
        } else {
            return data.array()
        }
    }
    
    fileprivate func getSeriesUpdateGroups() throws -> Elements {
        return try self.select("div.b-seriesupdate__block")
    }
}

extension Element {
    fileprivate func getId() throws -> String {
        return try self.getElementsByClass("td title").first()!
            .getElementsByTag("a").first()!
            .attr("href")
    }
    
    fileprivate func getName() throws -> String {
        return try self.getElementsByClass("td title").first()!
            .getElementsByTag("a")
            .text()
    }
    
    fileprivate func getDetails() throws -> String {
        return try self.getElementsByClass("td title").first()!
             .getElementsByTag("small")
             .text()
    }
    
    fileprivate func getWatchingInfo() throws -> String {
            let tdInfo = try self.getElementsByClass("td info").first()!
            
            return try tdInfo.text().replacingOccurrences(of: try tdInfo.getElementsByTag("span").first()?.text() ?? "", with: "")
    }
    
    fileprivate func getDataId() throws -> String {
        return try self.select("a.i-sprt.delete").first()!.attr("data-id")
    }
    
    fileprivate func getTrackedItems() throws -> Elements {
        return try self.select("li.b-seriesupdate__block_list_item.tracked")
    }
    
    fileprivate func getSeriesUpdateId() throws -> String {
        return try self.select("a.b-seriesupdate__block_list_link").attr("href")
    }
    
    fileprivate func getSeriesUpdateName() throws -> String {
        return try self.select("a.b-seriesupdate__block_list_link").text()
    }
    
    fileprivate func getSeriesUpdateSeason() throws -> String {
        return try self.select("span.season").text()
    }
    
    fileprivate func getSeriesUpdateReleasedEpisode() throws -> String {
        let span = try self.select("span.cell.cell-2")
        return try span.text().replacingOccurrences(of: span.select("i").text(), with: "")
    }
    
    fileprivate func getSeriesUpdateVoiceActing() throws -> String {
        return try self.select("span.cell.cell-2").select("i").text()
    }
    
    fileprivate func getDate() throws -> String {
        return try self.getElementsByClass("td date").text()
    }
    
    fileprivate func getButtonText() throws -> String? {
        let data = try self
            .getElementsByClass("td info")
            .first()?
            .getElementsByTag("span")
        
        if data?.array().first != nil {
            return try data?.text()
        } else {
            return nil
        }
    }
}
