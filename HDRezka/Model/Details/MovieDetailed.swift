//
//  MovieDetailed.swift
//  HDRezka
//
//  Created by keet on 24.09.2023.
//

import Foundation

struct MovieDetailed: Identifiable {
    /**
     * Movie id to get detailed movie info
     */
    let id: String
    /**
     * Movie name in Russian
     */
    let nameRussian: String
    /**
     * Original movie name
     */
    let nameOriginal: String? //null for russian movies
    /**
     * Link to movie poster image
     */
    let poster: String
    
    /**
     * Movie duration in minutes
     */
    let duration: String
    /**
     * Movie description
     */
    let description: String
    /**
     * Movie release date (DD month YYYY)
     */
    let releaseDate: String? //null if.. idk, just for some reason there could be no data
    /**
     * Country where movie was recorded
     */
    let country: String
    /**
     * Age restriction for movie
     */
    let ageRestriction: String
    /**
     * Movie IMDB rating
     */
    let imdbRating: MovieRating? //null if there's no movies on IMDb, or it's not popular
    /**
     * Movie KP rating
     */
    let kpRating: MovieRating? //null if there's no movies on Kinopoisk, or it's not popular
    /**
     * Movie genres
     */
    let genres: Array<MovieGenre>
    /**
     * Lists that movie is in
     */
    let lists: Array<MovieList>? //null if movie is not in any list
    /**
     * Collections that movies is in (id -> name)
     */
    let collections: [String: String]?
    
    /**
     * Series schedule
     */
    let schedule: Array<SeriesScheduleGroup>? //null if this is not a series
    /**
     * All the parts of the franchise
     */
    let franchise: Array<MovieFranchisePart>? //null if this is not a part of a franchise, or if it's a series
    
    /**
     * Movie producers
     */
    let producer: Array<PersonSimple>? //null if.. idk, just for some reason there could be no data
    /**
     * Movie actors
     */
    let actors: Array<PersonSimple>? //null if.. idk, just for some reason there could be no data
    
    /**
     * Link to movie YouTube trailer
     */
    var ytTrailerLink: String? //null if there's no trailer
    /**
     * Link to movie YouTube trailer preview image
     */
    let ytTrailerPreview: String? //null if there's no trailer
    
    /**
     * Is movie available in user's country
     */
    let availability: Availability
    /**
     * Is movie out or it will be out soon
     */
    let comingSoon: Bool
    /**
     * List of voice acting
     */
    let voiceActing: Array<MovieVoiceActing>? //null for single voice acting movies
    /**
     * Name of the single voice acting
     */
    let singleVoiceActingName: String?
    /**
     * Rating of voice acting choices
     */
    let voiceActingRating: Array<MovieVoiceActingRating>? //null for single voice acting movies
    /**
     * List of seasons for series
     */
    let seasons: Array<MovieSeason>? //null for single episode movies and cartoons
    /**
     * Pre-got video for movie with only one voice acting
     */
    let video: MovieVideo? //null for many voice acting movies
    
    let bookmarks: [Bookmark: Bool] // bookmarks list -> if movies is in the list
}

enum Availability {
    case AVAILABLE_ON_REZKA
    case UNAVAILABLE
}
