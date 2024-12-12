//
//  DetailSeasonModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 29/11/24.
//


import Foundation
import SwiftyJSON

class DetailSeasonModel {
    
    // MARK: - Properties
    var airDate: String = ""
    var episodeCount: Int = 0
    var id: Int = 0
    var name: String = ""
    var overview: String = ""
    var posterPath: String = ""
    var seasonNumber: Int = 0
    var voteAverage: Double = 0
    var episodes: [DetailEpisodeModel] = []
    
    // MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.airDate = json["air_date"].stringValue
        self.episodeCount = json["episode_count"].intValue
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.seasonNumber = json["season_number"].intValue
        self.voteAverage = json["vote_average"].doubleValue
        self.episodes = json["episodes"].arrayValue.map { DetailEpisodeModel(json: $0) }
    }
}

// MARK: - Api methods
extension DetailSeasonModel {
    
    static func fetchSeasonDetail(tvSeriesID: Int, seasonNumber: Int, completion: @escaping (Bool, DetailSeasonModel, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/tv/\(tvSeriesID)/season/\(seasonNumber)",
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
                let season = DetailSeasonModel(json: json)
                completion(true, season, "")
            case .failure(let error):
                completion(false, DetailSeasonModel(), error.localizedDescription)
            }
        }
    }
    
}
