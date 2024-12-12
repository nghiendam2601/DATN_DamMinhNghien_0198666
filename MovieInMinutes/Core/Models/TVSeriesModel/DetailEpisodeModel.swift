//
//  DetailEpisodeModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 29/11/24.
//

import SwiftyJSON


class DetailEpisodeModel {
    // MARK: - Properties
    var airDate: String = ""
    var episodeNumber: Int = 0
    var id: Int = 0
    var name: String = ""
    var overview: String = ""
    var runtime: Int = 0
    var seasonNumber: Int = 0
    var stillPath: String = ""
    var voteAverage: Double = 0
    var voteCount: Int = 0
    
    // MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.airDate = json["air_date"].stringValue
        self.episodeNumber = json["episode_number"].intValue
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.overview = json["overview"].stringValue
        self.runtime = json["runtime"].intValue
        self.seasonNumber = json["season_number"].intValue
        self.stillPath = json["still_path"].stringValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
    }
}


