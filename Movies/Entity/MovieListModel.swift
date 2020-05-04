//
//  MovieListModel.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import ObjectMapper

private let POPULARITY = "popularity"
private let VOTE_COUNT = "vote_count"
private let VIDEO = "video"
private let POSTER_PATH = "poster_path"
private let ID = "id"
private let ADULT = "adult"
private let BACKDROP_PATH = "backdrop_path"
private let ORIGINAL_LANGUAGE = "original_language"
private let ORIGINAL_TITLE = "original_title"
private let GENRE_IDS = "genre_ids"
private let TITLE = "title"
private let VOTE_AVERAGE = "vote_average"
private let OVERVIEW = "overview"
private let RELEASE_DATE = "release_date"


class MovieListModel: Mappable, Decodable{
    
    internal var popularity:Double?
    internal var voteCount:u_long?
    internal var video:Bool?
    internal var posterPath:String?
    internal var id:u_long?
    internal var adult:Bool?
    internal var backdropPath:String?
    internal var orgLang:String?
    internal var orgTitle:String?
    internal var geneIds:[u_long]?
    internal var title:String?
    internal var voteAvg:Double?
    internal var overview:String?
    internal var releaseDate:String?

    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map:Map){
        id <- map[ID]
        orgTitle <- map[ORIGINAL_TITLE]
        popularity <- map[POPULARITY]
        voteCount <- map[VOTE_COUNT]
        video <- map[VIDEO]
        posterPath <- map[POSTER_PATH]
        adult <- map[ADULT]
        backdropPath <- map[BACKDROP_PATH]
        orgLang <- map[ORIGINAL_LANGUAGE]
        geneIds <- map[GENRE_IDS]
        title <- map[TITLE]
        voteAvg <- map[VOTE_AVERAGE]
        overview <- map[OVERVIEW]
        releaseDate <- map[RELEASE_DATE]
    }
    
    enum CodingKeys: String, CodingKey {
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case posterPath = "poster_path"
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case orgLang = "original_language"
        case orgTitle = "original_title"
        case geneIds = "genre_ids"
        case title = "title"
        case voteAvg = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        popularity = try container.decode(Double.self, forKey: .popularity)
        voteCount = try container.decode(u_long.self, forKey: .voteCount)
        video = try container.decode(Bool.self, forKey: .video)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        id = try container.decode(u_long.self, forKey: .id)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decode(String.self, forKey: .backdropPath)
        orgLang = try container.decode(String.self, forKey: .orgLang)
        orgTitle = try container.decode(String.self, forKey: .orgTitle)
        geneIds = try container.decode(Array.self, forKey: .geneIds)
        title = try container.decode(String.self, forKey: .title)
        voteAvg = try container.decode(Double.self, forKey: .voteAvg)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}

