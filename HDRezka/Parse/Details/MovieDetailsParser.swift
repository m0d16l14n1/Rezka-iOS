//
//  MovieDetailsParser.swift
//  HDRezka
//
//  Created by keet on 24.09.2023.
//

import Foundation
import SwiftSoup

class MovieDetailsParser: ObservableObject {
    @Published var movieDetailed = [MovieDetailed]()
    
    @Published var movieSeason = [MovieSeason]()
    
    func parseMovieDetails(html: String, movieId: String) throws -> [MovieDetailed] {
        let site = try SwiftSoup.parse(html)
        let content = try site.getContent()
        
        let nameRussian = try content.getRussianName()
        let nameOriginal = try content.getOriginalName()
        let poster = try content.getDetailsPoster()
        let description = try content.getDescription()
        let isAvailable = site.isAvailable()
        let isComingSoon = site.isComingSoon()
        let seasons = isAvailable && !isComingSoon ? try site.getSeasons() : nil
        let voiceActing = isAvailable && !isComingSoon ? try site.getVoiceActing(movieId: movieId) : nil
        let schedule = try site.getSchedule()
        let franchise = try site.getFranchise()
        let voiceActingRating = !isComingSoon ? try site.getVoiceActingRating() : nil
        
        var imdbRating: Float? = nil
        var imdbVotes: String? = nil
        var kpRating: Float? = nil
        var kpVotes: String? = nil
        var releaseDate: String? = nil
        var producer: Array<PersonSimple>? = nil
        var ageRestriction: String? = nil
        var actors: [PersonSimple]? = nil
        var country: String? = nil
        var genre: Array<MovieGenre>? = nil
        var lists: Array<MovieList>? = nil
        var collections: [String: String]? = nil
        var duration: String? = nil
        var singleVoiceActingName: String? = nil
        
        
        content.getDetailsChunked(onGot: { chunk -> Void in
            do {
                switch try chunk.getName() {
                case "Рейтинги":
                    imdbRating = chunk.getImdbRating()
                    imdbVotes = chunk.getImdbVotes()
                    kpRating = try chunk.getKpRating()
                    kpVotes = chunk.getKpVotes()
                    
                case "Дата выхода":
                    releaseDate = try chunk[1].text()
                    
                case "Режиссер":
                    producer = try chunk.getProducers()
                    
                case "Возраст":
                    ageRestriction = try chunk.getAgeRestriction()
                    
                case "Страна":
                    country = try chunk[1].text()
                    
                case "Жанр":
                    genre = try chunk[1].getGenres()
                    
                case "Время":
                    duration = try chunk[1].text()
                    
                case "Входит в списки":
                    lists = try chunk[1].getMovieLists()
                    
                case "Из серии":
                    collections = try chunk[1].getMovieCollections()
                    
                case "В переводе":
                    singleVoiceActingName = try chunk[1].text()
                    
                default:
                    if let _ = chunk.getActors() {
                        actors = actors
                    }
                    break
                }
            } catch {
                print("error in parseMovieDetails")
            }
        })
        movieDetailed.append(MovieDetailed(id: "", // being set later
                                           nameRussian: nameRussian,
                                           nameOriginal: nameOriginal,
                                           poster: poster,
                                           duration: duration ?? "nil",
                                           description: description,
                                           releaseDate: releaseDate,
                                           country: country ?? "nil",
                                           ageRestriction: ageRestriction ?? "0+",
                                           imdbRating: imdbRating != nil && imdbVotes != nil ? MovieRating(value: imdbRating!,
                                                                                                           votesCount: imdbVotes!
                                                                                                          ) : nil,
                                           kpRating: kpRating != nil && kpVotes != nil ? MovieRating(value: kpRating!,
                                                                                                     votesCount: kpVotes!) : nil,
                                           genres: genre!,
                                           lists: lists,
                                           collections: collections,
                                           schedule: schedule,
                                           franchise: franchise,
                                           producer: producer,
                                           actors: actors,
                                           ytTrailerLink: nil,
                                           ytTrailerPreview: nil, // ??
                                           availability: isAvailable ? Availability.AVAILABLE_ON_REZKA : Availability.UNAVAILABLE,
                                           comingSoon: isComingSoon,
                                           voiceActing: voiceActing,
                                           singleVoiceActingName: singleVoiceActingName,
                                           voiceActingRating: voiceActingRating,
                                           seasons: seasons,
                                           video: nil,
                                           bookmarks: try site.getBookmarks()
                                          ))
        return movieDetailed
    }
    
    func parseSeriesSeasons(_ response: String) -> [MovieSeason]? {
        do {
            guard let jsonData = response.data(using: .utf8) else {
                return nil
            }
            
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return nil
            }
            
            guard let seasonsString = jsonObject["seasons"] as? String,
                  let episodesString = jsonObject["episodes"] as? String else {
                return nil
            }
            
            let seasonElements = try SwiftSoup.parse(seasonsString).body()?.select("li.b-simple_season__item") ?? Elements()
            
            for season in seasonElements {
                let seasonId = try season.attr("data-tab_id")
                let name = try season.text().replacingOccurrences(of: #"[^\d!-/:-@\[-`{-~]+"#, with: "", options: .regularExpression)
                let isSelected = try season.attr("class").contains("active")
                
                var seasonEpisodes = [MovieEpisode]()
                
                let episodeElements = try SwiftSoup.parse(episodesString).body()?.select("li.b-simple_episode__item[data-season_id=\(seasonId)]") ?? Elements()
                
                for episode in episodeElements {
                    let episodeId = try episode.attr("data-episode_id")
                    let episodeName = try episode.text().replacingOccurrences(of: #"[^\d!-/:-@\[-`{-~]+"#, with: "", options: .regularExpression)
                    let isActive = try episode.attr("class").contains("active")
                    
                    seasonEpisodes.append(
                        MovieEpisode(
                            id: episodeId,
                            name: episodeName,
                            isSelected: isActive
                        )
                    )
                }
                
                movieSeason.append(
                    MovieSeason(
                        id: seasonId,
                        name: name,
                        episodes: seasonEpisodes,
                        isSelected: isSelected
                    )
                )
            }
            
            return movieSeason
        } catch {
            print("error in parseSeriesSeasons")
            return nil
        }
    }
    
    static func insertTrailerData(id: String) async throws -> String? {
        var trailerResponse: String? = try await MovieDetailsService().getMovieTrailer(id.getMovieId())
        if ((trailerResponse?.isSuccess()) != nil) {
            trailerResponse = trailerResponse!.getTrailerLink()!
            
            return trailerResponse
        } else {
            trailerResponse = nil
        }
        
        return trailerResponse
    }

}

extension Document {
    func getContent() throws -> Element {
        return try self.select("div.b-content__main").first()!
    }
    
    func isAvailable() -> Bool {
        do {
            return try self.select("div.b-player__restricted").isEmpty()
        } catch {
            print("error in isAvailable")
            return false
        }
    }
    
    func isComingSoon() -> Bool {
        do {
            let result = try self.select("div.b-post__status_logo").isEmpty()
            return !result
        } catch {
            print("error in isComingSoon")
            return false
        }
    }
    
    func getSeasons() throws -> Array<MovieSeason>? {
        let emptySeasons = try self.select("ul#simple-seasons-tabs").isEmpty()
        let emptyEpisodes = try self.select("div#simple-episodes-tabs").isEmpty()
        let pattern = "[^\\d!-/:-@\\[-`{-~]+"
        
        if (emptySeasons && emptyEpisodes) { return nil }
        
        if (emptySeasons) {
            let id = try self.select("ul[id*=\"simple-episodes-list\"]").first()!
                .getElementsByClass("b-simple_episode__item").first()!
                .attr("data-season_id")
            let episodes = try select("ul#simple-episodes-list-\(id)").first()!
                .getElementsByClass("b-simple_episode__item")
                .map { episode in
                    return MovieEpisode(id: try episode.attr("data-episode_id"),
                                        name: try episode.text().replacingOccurrences(of: pattern, with: ""),
                                        isSelected: try episode.attr("class").contains("active"))
                }
            
            let season = MovieSeason(id: id,
                                     name: "Сезон \(id)".replacingOccurrences(of: pattern, with: ""),
                                     episodes: episodes,
                                     isSelected: true)
            
            return [season]
        } else {
            return try self.select("li.b-simple_season__item").map { season in
                let id = try season.attr("data-tab_id")
                let episodes = try select("ul#simple-episodes-list-\(id)").first()!
                    .getElementsByClass("b-simple_episode__item")
                    .map { episode in
                        return MovieEpisode(
                            id: try episode.attr("data-episode_id"),
                            name: try episode.text().replacingOccurrences(of: pattern, with: ""),
                            isSelected: try episode.attr("class").contains("active")
                        )
                    }
                
                return MovieSeason(id: id,
                                   name: try season.text().replacingOccurrences(of: pattern, with: ""),
                                   episodes: episodes,
                                   isSelected: try season.attr("class").contains("active"))
            }
        }
    }
    
    func getVoiceActing(movieId: String) throws -> Array<MovieVoiceActing> {
        let translatorsList = try self.select("ul#translators-list")
        
        if (!translatorsList.isEmpty()) {
            return try translatorsList.first()!
                .getElementsByTag("li")
                .map { element in
                    var name = try element.text()
                    if let language = try element.select("img").first()?.attr("title") {
                        name = name.addFlag(language)
                    } else {
                        name = try element.text()
                    }
                    
                    let translatorId = try element.attr("data-translator_id")
                    let isCamrip = try element.attr("data-camrip")
                    let isAds = try element.attr("data-ads")
                    let isDirector = try element.attr("data-director")
                    let isSelected = try element.attr("class").contains("active")
                    
                    return MovieVoiceActing(id: movieId, name: name, translatorId: translatorId, isCamrip: isCamrip, isAds: isAds, isDirector: isDirector, isSelected: isSelected)
                }
        } else {
            func getByOffset() throws -> Array<MovieVoiceActing> {
                let siteString = self.description
                var offsetKey = ""
                if siteString.contains("initCDNMoviesEvents") {
                    offsetKey = "initCDNMoviesEvents"
                } else {
                    offsetKey = "initCDNSeriesEvents"
                }
                
                let index = siteString.range(of: offsetKey)!.lowerBound
                let substring = siteString[index...]
                let translatorId = substring
                    .split(separator: ", ")[1]
                
                return [
                    MovieVoiceActing(
                        id: movieId,
                        name: "",
                        translatorId: String(translatorId),
                        isCamrip: "",
                        isAds: "",
                        isDirector: "",
                        isSelected: true
                    )
                ]
            }
            return try getByOffset() // try catch offsetKey ??
        }
    }
    
    func getSchedule() throws -> Array<SeriesScheduleGroup>? {
        if (try self.select("div.b-post__schedule_block").isEmpty()) { return nil }
        
        let schedule = try self.select("div.b-post__schedule_block").map { block in
            let blockTitle = try block
                .select("div.b-post__schedule_block_title")
                .select("div.title")
                .text()
            let items = try block
                .select("tr")
                .compactMap { item in
                    let title = try item.select("td.td-1").text()
                    let russianEpisodeName = try item.select("td.td-2").select("b").text()
                    let preOriginalEpisodeName = try item.select("td.td-2").select("span").text()
                    let originalEpisodeName = !preOriginalEpisodeName.isEmpty ? preOriginalEpisodeName : nil
                    let releaseDate = try item.select("td.td-4").text()
                    
                    return SeriesScheduleItem(
                        title: title,
                        russianEpisodeName: russianEpisodeName,
                        originalEpisodeName: originalEpisodeName,
                        releaseDate: releaseDate
                    )
                }
            
            return SeriesScheduleGroup(name: blockTitle, items: items)
        }
        
        return schedule
    }
    
    func getFranchise() throws -> Array<MovieFranchisePart>? {
        if try self.select("div.b-post__partcontent_item").isEmpty() { return nil }
        
        let franchise = try self.select("div.b-post__partcontent_item").compactMap { item in
            let name = try item.select("div.td.title").text()
            let id = try item.attr("data-url")
            let year = try item.select("div.td.year").text()
            let rating = try Float(item.select("div.td.rating").text())
            let current = item.hasClass("current")
            let position = try Int(item.select("div.td.num").text()) ?? 0
            
            return MovieFranchisePart(id: id,
                                      name: name,
                                      year: year,
                                      rating: rating,
                                      current: current,
                                      position: position
            )
        }
        
        return franchise
    }
    
    func getVoiceActingRating() throws -> Array<MovieVoiceActingRating>? {
        guard let popup = try self.select("span.b-rgstats__help").first else {
            return nil
        }
        let title = try popup.attr("title")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
        let items = try SwiftSoup.parse(title).body()?.select("div.inner")
        return try items.map { item in
            let prePercent = try item.select("div.count").text()
                .replacingOccurrences(of: "%", with: "")
                .replacingOccurrences(of: ",", with: ".")
            
            return [MovieVoiceActingRating(
                name: try { let language = try item.select("img").first?.attr("title") ?? ""
                    let name = try item.select("div.title").text()
                    return name.addFlag(language) }(),
                percent: Float(prePercent) ?? 0.0
            )]
        }
    }
    
    func getBookmarks() throws -> [Bookmark: Bool] {
        return try self.select("div#user-favorites-list").select("div.hd-label-row").reduce(into: [Bookmark: Bool]()) { result, element in
            let name = try element.getElementsByTag("label").text().components(separatedBy: "(").first ?? ""
            let id = try Int(element.getElementsByTag("input").attr("value")) ?? 0
            let isChecked = try element.getElementsByTag("input").hasAttr("checked")
            result[Bookmark(id: id, name: name)] = isChecked
        }
    }
}

extension Element {
    
    func getRussianName() throws -> String {
        return try self.getElementsByClass("b-post__title").first()!.text()
    }
    
    func getOriginalName() throws -> String? {
        return try self.getElementsByClass("b-post__origtitle").first()?.text()
    }
    
    func getDetailsPoster() throws -> String {
        return try self.select("div.b-sidecover").first()!
            .getElementsByTag("a").first()!
            .getElementsByTag("img").first()!
            .attr("src")
    }
    
    func getDetailsChunked(onGot: @escaping (_ chunk: [Element]) -> Void) {
        do {
            return try self.select("table.b-post__info").first()!
                .getElementsByTag("tbody")
                .forEach { tr in
                    try tr.getElementsByTag("tr").forEach { tableItem in
                        try tableItem.getElementsByTag("td").array().chunked(into: 2).forEach { chunk in
                            return onGot(chunk)
                        }
                    }
                }
        } catch {
            print("error getting chunked details")
        }
    }
    
    func getGenres() throws -> Array<MovieGenre> {
        let genreLinks = try self.getElementsByTag("a")
        let genres = try genreLinks.map { element -> MovieGenre in
            let link = try element.attr("href")
            let name = try element.text()
            return MovieGenre(id: link, name: name)
        }
        
        return genres
    }
    
    func getMovieLists() throws -> Array<MovieList> {
        let html = try self.outerHtml()
        let listItems = html.split(separator: "<br>")
        
        let movieList = try listItems.map { item -> MovieList in
            let listItem = try SwiftSoup.parse(String(item)).body()
            
            let link = try listItem?.getElementsByTag("a").first()!.attr("href")
            let name = try listItem?.getElementsByTag("a").first()!.text()
            
            let positionString = try listItem?.text().split(separator: "(")[1]
            let position = Int(positionString!.components(separatedBy: " ").dropLast().joined())
            
            return MovieList(id: link!, name: name!, moviePosition: position!)
        }
        
        return movieList
    }
    
    func getMovieCollections() throws -> [String: String] {
        let collectionLinks = try self.getElementsByTag("a")
        let collections = try collectionLinks.reduce(into: [String: String]()) { result, element in
            let link = try element.attr("href").replacingOccurrences(of: "collections/", with: "").dropLast()
            let name = try element.text()
            result[String(link)] = name
        }
        
        return collections
    }
    
    func getDescription() throws -> String {
        return try self.getElementsByClass("b-post__description").first()!
            .getElementsByClass("b-post__description_text").first()!.text()
    }
}

extension [Element] {
    func getName() throws -> String {
        return try self[0].getElementsByTag("h2").text()
    }
    
    func getImdbRating() -> Float? {
        do {
            let preRate = try self[1]
                .getElementsByClass("b-post__info_rates imdb").first()
            
            let rating = try preRate?.getElementsByClass("bold").first()?.text()
            if let rating = rating {
                return Float(rating)
            } else {
                return nil
            }
        } catch {
            print("error getting Imdb rating")
            return nil
        }
    }
    
    func getImdbVotes() -> String? {
        do {
            let preVotes =  try self[1].getElementsByClass("b-post__info_rates imdb").first()
            return try preVotes?.getElementsByTag("i").first()?.text().toShortNumber()
        } catch {
            print("error getting Imdb votes")
            return nil
        }
    }
    
    func getKpVotes() -> String? {
        do {
            let preVotes =  try self[1].getElementsByClass("b-post__info_rates kp").first()
            return try preVotes?.getElementsByTag("i").first()?.text().toShortNumber()
        } catch {
            print("error getting kp votes")
            return nil
        }
    }
    
    func getKpRating() throws -> Float? {
        let result = try self[1].getElementsByClass("b-post__info_rates kp").first()?.getElementsByClass("bold").first()?.text() ?? "0"
        return Float(result)
    }
    
    func getProducers() throws -> Array<PersonSimple> {
        let producerLinks = try self[1]
            .getElementsByClass("persons-list-holder").first()!
            .select("a")
        
        return try producerLinks.map { result in
            let link = try result.attr("href")
            let name = try result.text()
            return PersonSimple(id: link, name: name)
        }
    }
    
    func getAgeRestriction() throws -> String {
        return try self[1].getElementsByTag("span").first()!.text()
    }
    
    func getActors() -> Array<PersonSimple>? {
        do {
            let actorsList = try self[0]
                .getElementsByTag("div")
            
            if actorsList.isEmpty {
                return nil
            } else {
                return try actorsList.select("a").first().map { actor in
                    let link = try actor.attr("href")
                    let name = try actor.text()
                    return [PersonSimple(id: link, name: name)]
                }
            }
        } catch {
            print("error getting actors")
            return nil
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension String {
    
    func getMovieId() -> String {
        return String((self.components(separatedBy: "/").last?.components(separatedBy: "-").first) ?? "")
    }
    
    func isSuccess() -> Bool {
        guard let jsonData = self.data(using: .utf8) else {
            return false
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDict = jsonObject as? [String: Any], let success = jsonDict["success"] as? Bool {
                return success
            }
        } catch {
            return false
        }
        
        return false
    }
    
    func getTrailerLink() -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: Data(self.utf8), options: []),
              let jsonDict = jsonObject as? [String: Any],
              let code = jsonDict["code"] as? String else {
            return nil
        }
        
        guard let doc = try? SwiftSoup.parse(code),
              let iframe = try? doc.getElementsByTag("iframe").first(),
              let src = try? iframe.attr("src"),
              let playerLink = src.replacingOccurrences(of: "https://www.youtube.com/embed/", with: "").components(separatedBy: "?").first else {
            return nil
        }
        
        return "https://youtu.be/\(playerLink)"
    }
    
    func addFlag(_ language: String) -> String {
        switch language {
        case "Украинский":
            return self + " 🇺🇦"
        case "Казахский":
            return self + " 🇰🇿"
        default:
            return self
        }
    }
    
    func getMovieVideo() -> MovieVideo {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as! [String: Any]
            
            let streams = jsonObject["url"] as! String
            
            var videoMap = [String: String]()
            streams.split(separator: ",").forEach { stream in
                let video = stream.replacingOccurrences(of: "[", with: "").trimmingCharacters(in: .whitespaces)
                let name = video.split(separator: "]")[0]
                let linkMP4 = video
                    .split(separator: "]")[1]
                    .split(separator: " or ")[1]
                    .replacingOccurrences(of: ":hls:manifest.m3u8", with: "")
                
//                if self.checkIfLinkIsBroken(linkMP4) {
//                    fatalError("getMovieVideo, link is broken")
//                }
                
                return videoMap[String(name)] = String(linkMP4)
            }
            
            return MovieVideo(
                name: "",
                _360p: videoMap["360p"],
                _480p: videoMap["480p"],
                _720p: videoMap["720p"],
                _1080p: videoMap["1080p"],
                _1080pUltra: videoMap["1080p Ultra"],
                _1440p: videoMap["1440p"],
                _2160p: videoMap["2160p"],
                position: 0
            )
        } catch {
            print("error in getMovieVideo")
            return MovieVideo(name: "", _360p: "", _480p: "", _720p: "", _1080p: "", _1080pUltra: "", _1440p: "", _2160p: "", position: 1)
        }
    }
}
