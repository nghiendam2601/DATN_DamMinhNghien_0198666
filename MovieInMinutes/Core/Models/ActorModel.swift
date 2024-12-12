//
//  MovieModel 2.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 10/11/24.
//


import Foundation
import SwiftyJSON

class ActorModel {
    
    //MARK: - Properties
    var id: Int = 0
    var name: String = ""
    var profilePath: String = ""
    var character: String = ""
    var biography: String = ""
    var birthday: String = ""
    var deathday: String = ""
    var gender: Int = 0
    var homepage: String = ""
    var imdbID: String = ""
    var knownForDepartment: String = ""
    var placeOfBirth: String = ""
    var popularity: Double = 0
    
    //MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.profilePath = json["profile_path"].stringValue
        self.character = json["character"].stringValue
        self.biography = json["biography"].stringValue
        self.birthday = json["birthday"].stringValue
        self.deathday = json["deathday"].stringValue
        self.gender = json["gender"].intValue
        self.homepage = json["homepage"].stringValue
        self.imdbID = json["imdb_id"].stringValue
        self.knownForDepartment = json["known_for_department"].stringValue
        self.placeOfBirth = json["place_of_birth"].stringValue
        self.popularity = json["popularity"].doubleValue
    }
}
//MARK: - API Methods
extension ActorModel {
    
    static func fetchCast(category: Category,Auth: String,id: Int, completion: @escaping (Bool, [ActorModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/\(category.rawValue)/\(id)/credits",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Auth)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let cast = json["cast"].arrayValue.map { ActorModel(json: $0) }
                completion(true, cast, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    static func fetchDetailActor(id: Int, completion: @escaping (Bool, ActorModel, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/person/\(id)",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let actor = ActorModel(json: json)
                completion(true, actor, "")
            case .failure(let error):
                completion(false, ActorModel(), error.localizedDescription)
            }
        }
    }
    
}
