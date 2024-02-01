//
//  CollectionsParser.swift
//  HDRezka
//
//  Created by keet on 21.11.2023.
//

import Foundation
import SwiftSoup

@MainActor class CollectionsParser: ObservableObject {
    @Published var collections = [Collection]()
    
    @Published var moviesInCollections = [MovieSimple]()
    
    func parseCollections(_ html: String) throws -> [Collection] {
        let document = try SwiftSoup.parse(html)
        
        try document.getCollections().forEach { collection in
                let id = try collection.getId().components(separatedBy: "/")[3] // unsecure?
                let name = try collection.getName()
                let poster = try collection.getPoster()
                let count = try collection.getCountOfMovies()
                
                let collection = Collection(id: id, name: name, poster: poster, count: count)
                
                collections.append(collection)
            }
        
        return collections
    }
    
    func parseMoviesInCollection(_ html: String) throws -> [MovieSimple] {
        let document = try SwiftSoup.parse(html)
        
        try document
            .getMovies()
            .forEach { movie in
                let id = try movie.getMovieId()
                let name = try movie.getMovieTitle()
                let details = try movie.getMovieDetails().replacingOccurrences(of: "\(name) ", with: "") //костыль
                let poster = try movie.getMoviePoster()
                
                let movieSimple = MovieSimple(id: id, name: name, details: details, poster: poster)
                
                moviesInCollections.append(movieSimple)
            }
        
        return moviesInCollections
    }
    
    func getCollections(page: Int) async throws -> [Collection] {
        try await self.parseCollections(CollectionsNetwork().getCollections(page: page))
    }
    
    func getMoviesInCollection(collectionId: String, page: Int) async throws -> [MovieSimple] { // ??
        try await self.parseMoviesInCollection(CollectionsNetwork().getMoviesInCollection(id: collectionId, page: page))
    }
    
    func getMoviesInCollectionFiltered(collectionId: String, page: Int, filter: String) async throws -> [MovieSimple] {
        try await self.parseMoviesInCollection(CollectionsNetwork().getMoviesInCollectionFiltered(id: collectionId, page: page, filter: filter))
    }
    
    func getWatchingNowMoviesInCollection(collectionId: String, page: Int) async throws -> [MovieSimple] {
        try await self.parseMoviesInCollection(CollectionsNetwork().getMoviesInCollectionFiltered(id: collectionId, page: page, filter: "watching"))
    }
}

fileprivate extension Document {
    func getCollections() throws -> Elements {
        return try self.select("div.b-content__collections_item")
    }
    
    func getMovies() throws -> Elements {
        return try self.select("div.b-content__inline_item")
    }
}

fileprivate extension Element {
    func getName() throws -> String {
        return try self.getElementsByClass("title-layer").first()!
            .getElementsByTag("a").first()!
            .text()
    }
    
    func getPoster() throws -> String {
        return try self.getElementsByTag("img").first()!
            .attr("src")
    }
    
    func getCountOfMovies() throws -> Int {
        return try Int(self.getElementsByClass("num hd-tooltip").first()!.text())!
    }
    
    func getId() throws -> String {
        return try String(self.attr("data-url")
            .replacingOccurrences(of: "collections/", with: "")
            .dropLast())
    }
    
    func getMovieTitle() throws -> String {
        return try self.getElementsByClass("b-content__inline_item-link").first()!
            .getElementsByTag("a").first()!
            .text()
    }
    
    func getMovieDetails() throws -> String {
        return try self.getElementsByClass("b-content__inline_item-link").first()!
            .getElementsByTag("div").first()!
            .text()
    }
    
    func getMoviePoster() throws -> String {
        return try self.getElementsByClass("b-content__inline_item-cover").first()!
            .getElementsByTag("a").first()!
            .getElementsByTag("img").first()!
            .attr("src")
    }
    
    func getMovieId() throws -> String {
        return try self.attr("data-url")
    }
}
