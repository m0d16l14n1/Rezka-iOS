//
//  Network.swift
//  HDRezka
//
//  Created by keet on 21.09.2023.
//

import Foundation
import SwiftSoup

class Network: ObservableObject {
    @Published var nowWatchingMovies = [MovieSimple]()
    
    @Published var movies = [MovieSimple]()
    
    @Published var search = [MovieSimple]()
    
    @Published var quickSearch = [SearchResult]()
    
    // MARK: movie list parser
    func parse(html: String) throws -> Array<MovieSimple> {
        let site = try SwiftSoup.parse(html)
        
        site.getMovies()?.forEach { movie in
            let id = movie.getId()
            let name = movie.getTitle()
            let details = movie.getDetails()?.replacingOccurrences(of: "\(name ?? "") ", with: "") // костыль
            let poster = movie.getPoster()
            let movieSimple = MovieSimple(id: id!, name: name!, details: details!, poster: poster!)
            
            movies.append(movieSimple)
        }
        
        return movies
    }
    
    func parseNowWatchingMovies(html: String) throws -> Array<MovieSimple> {
        let site = try SwiftSoup.parse(html)
        
        site.getMovies()?.forEach { movie in
            let id = movie.getId()
            let name = movie.getTitle()
            let details = movie.getDetails()?.replacingOccurrences(of: "\(name ?? "") ", with: "") // костыль
            let poster = movie.getPoster()
            let movieSimple = MovieSimple(id: id!, name: name!, details: details!, poster: poster!)
            
            nowWatchingMovies.append(movieSimple)
        }
        
        return nowWatchingMovies
    }
    
    func parseSearch(html: String) throws -> Array<MovieSimple> {
        let site = try SwiftSoup.parse(html)
        
        site.getMovies()?.forEach { movie in
            let id = movie.getId()
            let name = movie.getTitle()
            let details = movie.getDetails()?.replacingOccurrences(of: "\(name ?? "idk") ", with: "") // костыль
            let poster = movie.getPoster()
            let movieSimple = MovieSimple(id: id!, name: name!, details: details!, poster: poster!)
            
            search.append(movieSimple)
        }
        
        return search
    }
    
    func parseQuickSearch(html: String) throws -> Array<SearchResult> {
        let document = try SwiftSoup.parse(html)
        
        document.getSearchResults()?.forEach { movie in
            let movieId = movie.getIdSearch()
            let name = movie.getNameSearch()
            let details = movie.getDetailsSearch()
            
            let searchResult = SearchResult(id: movieId!, name: name!, details: details!)
            
            quickSearch.append(searchResult)
        }
        
        return quickSearch
    }
}

fileprivate extension Document {
    func getMovies() -> Elements? {
        do {
            return try self.select("div.b-content__inline_item")
        } catch {
            print("error")
            return nil
        }
    }
    
    func getSearchResults() -> Elements? {
        do {
            if (try self.body()!
                .getElementsByClass("b-search__live_section").first()?
                .getElementsByClass("b-search__section_list").first()?
                .getElementsByTag("li")) != nil {
                
                return try self.body()!
                    .getElementsByClass("b-search__live_section").first()!
                    .getElementsByClass("b-search__section_list").first()!
                    .getElementsByTag("li")
            } else {
                return nil
            }
        } catch {
            print("error")
            return nil
        }
    }
}

fileprivate extension Element {
    func getId() -> String? {
        do {
            let preres = try self.attr("data-url")
            let result = String(preres.drop(while: { $0 == "/" }))
            
            return result
        } catch {
            print("error")
            return nil
        }
    }
    
    func getIdSearch() -> String? {
        do {
            return try self.getElementsByTag("a").first()!
                .attr("href")
        } catch {
            print("error")
            return nil
        }
    }
    
    func getMovieId() -> String? {
        do {
            return try self.attr("data-url")
        } catch {
            print("error")
            return nil
        }
    }
    
    func getTitle() -> String? {
        do {
            return try self.getElementsByClass("b-content__inline_item-link").first()!
                .getElementsByTag("a").first()!
                .text()
        } catch {
            print("error")
            return nil
        }
    }
    
    func getDetails() -> String? {
        do {
            return try self.getElementsByClass("b-content__inline_item-link").first()!
                .getElementsByTag("div").first()!
                .text()
        } catch {
            print("error")
            return nil
        }
    }
    
    func getDetailsSearch() -> String? {
        do {
            let prerate = try self
                .getElementsByTag("a").first()!
                .getElementsByClass("rating").first()
            let rating = try prerate?.text()
            
            let name = try self
                .getElementsByTag("a").first()!
                .text()
                .replacingOccurrences(of: self.getNameSearch()!, with: "")
            
            return rating != nil ? name.replacingOccurrences(of: rating!, with: "") : name
        } catch {
            print("error")
            return nil
        }
    }
    
    func getPoster() -> String? {
        do {
            return try self.getElementsByClass("b-content__inline_item-cover").first()!
                .getElementsByTag("a").first()!
                .getElementsByTag("img").first()!
                .attr("src")
        } catch {
            print("error")
            return nil
        }
    }
    
    func getNameSearch() -> String? {
        do {
            return try self
                .getElementsByTag("a").first()!
                .getElementsByClass("enty").first()!
                .text()
        } catch {
            print("error")
            return nil
        }
    }
}
