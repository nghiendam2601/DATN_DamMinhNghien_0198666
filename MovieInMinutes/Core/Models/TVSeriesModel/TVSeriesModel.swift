//
//  TVSeries 2.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/10/24.
//


import Foundation
import SwiftyJSON

class TVSeriesModel {
    
    // MARK: - Properties
    var backdropPath: String = ""
    var genreIDs: [Int] = []
    var genres: [String] = []
    var id: Int = 0
    var overview: String = ""
    var posterPath: String = ""
    var firstAirDate: String = ""
    var name: String = ""
    var originalTitle: String = ""
    var voteAverage: Double = 0
    var voteCount: Int = 0
    var status: String = ""
    var numberOfEpisodes: Int = 0
    var type: String = ""
    var rating: Double = 0
    var seasons: [DetailSeasonModel] = [] 
    
    // MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.backdropPath = json["backdrop_path"].stringValue
        self.id = json["id"].intValue
        self.overview = json["overview"].stringValue
        self.rating = json["rating"].doubleValue
        self.posterPath = json["poster_path"].stringValue
        self.firstAirDate = json["first_air_date"].stringValue
        self.name = json["name"].stringValue
        self.originalTitle = json["original_name"].stringValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
        self.genreIDs = json["genre_ids"].arrayValue.map { $0.intValue }
        self.genres = json["genres"].arrayValue.map { $0["name"].stringValue }
        self.status = json["status"].stringValue
        self.numberOfEpisodes = json["number_of_episodes"].intValue
        self.type = json["type"].stringValue
        
        // Map season data to DetailSeasonModel
        self.seasons = json["seasons"].arrayValue.map { DetailSeasonModel(json: $0) }
    }
}

//MARK: - API methods
extension TVSeriesModel {
    
    static func fetchTVSeriesList(auth: String, type: TVSeriesListType, completion: @escaping (Bool, [TVSeriesModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/tv/\(type.rawValue)",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: auth)
            ]
        )
        
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let tvSeriesList = json["results"].arrayValue.map { TVSeriesModel(json: $0) }
                completion(true, tvSeriesList, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    static func fetchTrendingTVSeries(completion: @escaping (Bool, [TVSeriesModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/trending/tv/day",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let tvSeriesList = json["results"].arrayValue.map { TVSeriesModel(json: $0) }
                completion(true, tvSeriesList, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    static func fetchTVSeriesDetail(id: Int, completion: @escaping (Bool, TVSeriesModel, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/tv/\(id)",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let tv = TVSeriesModel(json: json)
                completion(true, tv, "")
            case .failure(let error):
                completion(false, TVSeriesModel(), error.localizedDescription)
            }
        }
    }
    
    static func deleteRatingTVSeries(tvSeriesID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/tv/\(tvSeriesID)/rating",
            method: "DELETE",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                print(json["status_message"])
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func ratingTVSeries(tvSeriesID: Int, score: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/tv/\(tvSeriesID)/rating",
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
            ],
            body: [
                "value": "\(score * 2)"
            ],
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                print(json["status_message"])
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func fetchRatedTV(accountID: Int, sessionID: String, completion: @escaping (Bool, [TVSeriesModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/account/\(accountID)/rated/tv",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "sort_by", value: "created_at.asc"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                for tv in json["results"].arrayValue {
                    let id = tv["id"].intValue
                    let rating = tv["rating"].doubleValue
                    AppConstant.tvRated[id] = rating
                }
                let tvSeriesList = json["results"].arrayValue.map { TVSeriesModel(json: $0) }
                completion(true,tvSeriesList, "")
            case .failure(let error):
                completion(false,[], error.localizedDescription)
            }
        }
    }
    
}
