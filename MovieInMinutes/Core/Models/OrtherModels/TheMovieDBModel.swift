//
//  TheMovieDBModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 15/11/24.
//

import Foundation

class TheMovieDBModel {
    
    //MARK: - Methods
    static func searchMulti(Auth: String, query: String, completion: @escaping (Bool, [(Any, String)], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/search/multi",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "api_key", value: Auth)
            ]
        )
        
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                guard let results = json["results"].array else {
                    completion(false, [], "Invalid data format")
                    return
                }
                
                // Mảng để lưu kết quả
                var resultsArray: [(Any, String)] = []
                for item in results {
                    let mediaType = item["media_type"].stringValue
                    switch mediaType {
                    case "movie":
                        let movie = MovieModel(json: item)
                        resultsArray.append((movie, LanguageDictionary.movies.dictionary))
                    case "tv":
                        let tv = TVSeriesModel(json: item)
                        resultsArray.append((tv, LanguageDictionary.tvSeries.dictionary))
                    case "person":
                        let actor = ActorModel(json: item)
                        resultsArray.append((actor, LanguageDictionary.person.dictionary))
                    default:
                        break // Bỏ qua nếu media_type không xác định
                    }
                }
                
                // Trả về kết quả
                completion(true, resultsArray, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
}
