//
//  MyListModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import SwiftyJSON
import Foundation


class MyListModel {
    
    //MARK: - Properties
    var id: Int = 0
    var name: String = ""
    var description: String = ""
    var favoriteCount: Int = 0
    var itemCount: Int = 0
    var iso6391: String = ""
    var listType: String = ""
    var posterPath: String? = nil
    var movies: [MovieModel] = []
    
    //MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.favoriteCount = json["favorite_count"].intValue
        self.itemCount = json["item_count"].intValue
        self.iso6391 = json["iso_639_1"].stringValue
        self.listType = json["list_type"].stringValue
        self.posterPath = json["poster_path"].string
    }
    
    func updateDetailList(movies: [MovieModel]) {
        self.movies += movies
    }
}

//MARK: - Methods
extension MyListModel {
    
    static func fetchDetailList(listID: Int, sessionID: String, completion: @escaping (Bool, [MovieModel], String) -> Void) {
        // URL cho endpoint lấy chi tiết danh sách
        let url = "https://api.themoviedb.org/3/list/\(listID)"
        
        // Tạo request
        let request = HttpRequest(
            url: url,
            method: "GET",
            headers: [
                "Accept": "application/json"
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                
                // Kiểm tra nếu danh sách items tồn tại
                if let items = json["items"].array {
                    // Parse các phim từ mảng items
                    let movies = items.map { MovieModel(json: $0) }
                    completion(true, movies, "")
                } else {
                    let statusMessage = json["status_message"].stringValue
                    completion(false, [], statusMessage.isEmpty ? "No items found in the list." : statusMessage)
                }
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    
    static func addMovieToList(listID: Int, movieID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        // URL cho endpoint thêm phim vào danh sách
        let url = "https://api.themoviedb.org/3/list/\(listID)/add_item"
        // Body yêu cầu, bao gồm `media_id` của phim
        // Tạo request
        let request = HttpRequest(
            url: url,
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: ["media_id": "\(movieID)"],
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let success = json["success"].boolValue
                let statusMessage = json["status_message"].stringValue
                if success {
                    completion(true, "Movie added successfully.")
                } else {
                    completion(false, statusMessage.isEmpty ? "Failed to add movie." : statusMessage)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func checkItemStatus(listID: Int, movieID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let url = "https://api.themoviedb.org/3/list/\(listID)/item_status"
        
        let request = HttpRequest(
            url: url,
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "movie_id", value: "\(movieID)"),
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let itemPresent = json["item_present"].boolValue
                if itemPresent {
                    completion(false, "")
                } else {
                    completion(true, "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func clearList(listID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let url = "https://api.themoviedb.org/3/list/\(listID)/clear"
        let request = HttpRequest(
            url: url,
            method: "POST",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "confirm", value: "true"),
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let success = json["success"].boolValue
                if success {
                    completion(true, "")
                } else {
                    completion(false, "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func removeMovieFromList(listID: Int, movieID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        // URL cho endpoint thêm phim vào danh sách
        let url = "https://api.themoviedb.org/3/list/\(listID)/remove_item"
        // Body yêu cầu, bao gồm `media_id` của phim
        // Tạo request
        let request = HttpRequest(
            url: url,
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: ["media_id": "\(movieID)"],
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let success = json["success"].boolValue
                let statusMessage = json["status_message"].stringValue
                if success {
                    completion(true, "Remove movie successfully.")
                } else {
                    completion(false, statusMessage.isEmpty ? "Failed to remove movie." : statusMessage)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func deleteList(listID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        // URL cho endpoint thêm phim vào danh sách
        let url = "https://api.themoviedb.org/3/list/\(listID)"
        // Body yêu cầu, bao gồm `media_id` của phim
        // Tạo request
        let request = HttpRequest(
            url: url,
            method: "DELETE",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let success = json["success"].boolValue
                let statusMessage = json["status_message"].stringValue
                if success {
                    completion(true, "Delete list successfully.")
                } else {
                    completion(false, statusMessage.isEmpty ? "Failed to delete list." : statusMessage)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func createList(name: String, des: String, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let url = "https://api.themoviedb.org/3/list"
        
        let request = HttpRequest(
            url: url,
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json",
            ],
            body: ["name": name,
                   "description": des,
                   "language": "\(SettingsManager.shared.currentLanguage.rawValue)"],
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        print(SettingsManager.shared.currentLanguage.rawValue)
        // Gọi API
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let success = json["success"].boolValue
                let statusMessage = json["status_message"].stringValue
                if success {
                    completion(true, "Create list successfully.")
                } else {
                    completion(false, statusMessage.isEmpty ? "Failed to Create list." : statusMessage)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
}
